defmodule Rauversion.PurchaseOrders do
  alias Ecto.Multi

  @moduledoc """
  The PurchaseOrders context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.PurchaseOrders.PurchaseOrder

  @doc """
  Returns the list of purchase_orders.

  ## Examples

      iex> list_purchase_orders()
      [%PurchaseOrder{}, ...]

  """
  def list_purchase_orders do
    Repo.all(PurchaseOrder)
  end

  @doc """
  Gets a single purchase_order.

  Raises `Ecto.NoResultsError` if the Purchase order does not exist.

  ## Examples

      iex> get_purchase_order!(123)
      %PurchaseOrder{}

      iex> get_purchase_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_purchase_order!(id), do: Repo.get!(PurchaseOrder, id)

  def get_purchase_order_by_stripe_payment!(id),
    do: Repo.get_by!(PurchaseOrder, payment_id: id, payment_provider: "stripe")

  @doc """
  Creates a purchase_order.

  ## Examples

      iex> create_purchase_order(%{field: value})
      {:ok, %PurchaseOrder{}}

      iex> create_purchase_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_purchase_order(attrs \\ %{}) do
    %PurchaseOrder{}
    |> PurchaseOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a purchase_order.

  ## Examples

      iex> update_purchase_order(purchase_order, %{field: new_value})
      {:ok, %PurchaseOrder{}}

      iex> update_purchase_order(purchase_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_purchase_order(%PurchaseOrder{} = purchase_order, attrs) do
    purchase_order
    |> PurchaseOrder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a purchase_order.

  ## Examples

      iex> delete_purchase_order(purchase_order)
      {:ok, %PurchaseOrder{}}

      iex> delete_purchase_order(purchase_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_purchase_order(%PurchaseOrder{} = purchase_order) do
    Repo.delete(purchase_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking purchase_order changes.

  ## Examples

      iex> change_purchase_order(purchase_order)
      %Ecto.Changeset{data: %PurchaseOrder{}}

  """
  def change_purchase_order(%PurchaseOrder{} = purchase_order, attrs \\ %{}) do
    PurchaseOrder.changeset(purchase_order, attrs)
  end

  def calculate_total(order, ccy \\ "usd") do
    order.data
    |> Enum.filter(fn x -> x.count != 0 end)
    |> Enum.map(fn x ->
      ticket = Rauversion.EventTickets.get_event_ticket!(x.ticket_id)

      case ccy do
        "usd" -> Decimal.to_float(ticket.price) * x.count
        "clp" -> Decimal.to_integer(ticket.price) * x.count
      end
    end)
    |> Enum.sum()
  end

  def calculate_fee(total, cyy \\ "usd")

  def calculate_fee(total = %Decimal{}, ccy) do
    t = total.coef / (app_fee() * 100.0)

    case ccy do
      "usd" -> t
      "clp" -> t |> Kernel.round()
    end
  end

  def calculate_fee(total, ccy) do
    t = total / (app_fee() * 100.0)

    case ccy do
      "usd" -> t
      "clp" -> t |> Kernel.round()
    end
  end

  def app_fee do
    {platform_fee, _} = Float.parse(Application.get_env(:rauversion, :platform_event_fee))
    platform_fee
  end

  def create_stripe_session(order, event = %Rauversion.Events.Event{}) do
    client = Rauversion.Stripe.Client.new()
    user = event |> Ecto.assoc(:user) |> Repo.one()

    c = Rauversion.Accounts.get_oauth_credential(user, "stripe")

    line_items =
      order.data
      |> Enum.filter(fn x -> x.count != 0 end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {x, i}, acc ->
        ticket = Rauversion.EventTickets.get_event_ticket!(x.ticket_id)

        acc
        |> Map.merge(%{
          "#{i}" => %{
            "quantity" => x.count,
            "price_data" => %{
              "unit_amount" => Decimal.to_integer(ticket.price) * 100,
              "currency" => event.event_settings.ticket_currency,
              "product_data" => %{
                "name" => ticket.title,
                "description" => ticket.short_description
              }
            }
          }
        })
      end)

    total = Rauversion.PurchaseOrders.calculate_total(order, event.event_settings.ticket_currency)

    fee_amount =
      Rauversion.PurchaseOrders.calculate_fee(total, event.event_settings.ticket_currency)

    Rauversion.Stripe.Client.create_session(
      client,
      c.uid,
      %{
        "line_items" => line_items,
        "payment_intent_data" => %{
          "application_fee_amount" => fee_amount
          # "transfer_data"=> %{
          #  "destination"=> c.uid
          # }
        },
        "mode" => "payment",
        "success_url" =>
          RauversionWeb.Router.Helpers.events_show_url(
            RauversionWeb.Endpoint,
            :payment_success,
            event.slug
          ),
        "cancel_url" =>
          RauversionWeb.Router.Helpers.events_show_url(
            RauversionWeb.Endpoint,
            :payment_cancel,
            event.slug
          )
      }
    )
  end

  def create_stripe_order(event, user_id, purchase_order) do
    {:ok, a} =
      Rauversion.PurchaseOrders.create_purchase_order(
        %{
          "user_id" => user_id
        }
        |> Map.merge(purchase_order)
      )

    {:ok, data} =
      Rauversion.PurchaseOrders.create_stripe_session(
        a,
        event
      )

    {:ok, order_with_payment_id} =
      Rauversion.PurchaseOrders.update_purchase_order(a, %{
        "payment_id" => data["id"],
        "payment_provider" => "stripe",
        "total" => calculate_total(a)
      })

    {:ok, %{resp: data, order: order_with_payment_id}}
  end

  def generate_purchased_tickets(order) do
    Multi.new()
    |> Multi.run(:purchased_tickets, fn _repo, _ ->
      IO.inspect("PASO POR ACA!")

      purchased_tickets =
        order.data
        |> Enum.map(fn ticket ->
          Enum.map(0..ticket.count, fn
            0 ->
              :noop

            _ ->
              t = Rauversion.EventTickets.get_event_ticket!(ticket.ticket_id)
              IO.inspect("CREANDO TICKETE")

              Rauversion.PurchasedTickets.create_purchased_ticket(%{
                "user_id" => order.user_id,
                "purchase_order_id" => order.id,
                "event_ticket_id" => ticket.ticket_id,
                "state" => "paid",
                "data" => %{"price" => t.price}
              })
          end)
        end)
        |> List.flatten()

      errs =
        purchased_tickets
        |> Enum.any?(fn x ->
          case x do
            {:error, _} -> true
            _ -> false
          end
        end)

      case errs do
        true ->
          {:error, nil}

        false ->
          {:ok,
           purchased_tickets
           |> Enum.map(fn x ->
             case x do
               {:ok, r} -> r
               _ -> nil
             end
           end)
           |> Enum.filter(fn x -> x end)}
      end
    end)
    |> Repo.transaction()
  end

  # transbank
  def commit_order(event, token) do
    commerce_code = Application.get_env(:rauversion, :tbk_mall_id)
    api_key = Application.get_env(:rauversion, :tbk_api_key)

    trx =
      Transbank.Webpay.WebpayPlus.MallTransaction.new(
        commerce_code,
        api_key,
        transbank_environment(event)
      )

    {:ok, data} = Transbank.Webpay.WebpayPlus.MallTransaction.commit(trx, token)

    # TODO: save data on some transacion table?
    case data do
      %{"vci" => "TSY"} ->
        Rauversion.PurchaseOrders.get_purchase_order!(data["buy_order"])
        |> generate_purchased_tickets()

      _ ->
        {:error, nil}
    end

    # %{
    #   "accounting_date" => "0913",
    #   "buy_order" => "39",
    #   "card_detail" => %{"card_number" => "6623"},
    #   "details" => [
    #     %{
    #       "amount" => 160,
    #       "authorization_code" => "1213",
    #       "buy_order" => "39",
    #       "commerce_code" => "597055555536",
    #       "installments_number" => 0,
    #       "payment_type_code" => "VN",
    #       "response_code" => 0,
    #       "status" => "AUTHORIZED"
    #     }
    #   ],
    #   "session_id" => "39-1",
    #   "transaction_date" => "2022-09-14T02:58:39.305Z",
    #   "vci" => "TSY"
    # }
  end

  def transbank_environment(event) do
    case event.user.settings.tbk_test_mode do
      true -> Transbank.Webpay.WebpayPlus.MallTransaction.default_environment()
      _ -> :production
    end
  end

  def create_transbank_order(event, purchase_order, user_id) do
    # uuid implementations

    # filename = :os.system_time
    # id = :crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)

    Multi.new()
    |> Multi.insert(
      :purchase_order,
      PurchaseOrder.changeset(
        %PurchaseOrder{},
        %{
          "user_id" => user_id,
          "payment_id" => "e-#{event.id}-",
          "payment_provider" => "transbank"
        }
        |> Map.merge(purchase_order)
      )
    )
    |> Multi.run(:create_transaction, fn _repo, %{purchase_order: order} ->
      # Transbank.Common.IntegrationCommerceCodes.webpay_plus_mall()
      # commerce_code = Application.get_env(:rauversion, :tbk_mall_id)
      # Transbank.Common.IntegrationApiKeys.webpay()
      # api_key = Application.get_env(:rauversion, :tbk_api_key)

      trx =
        Transbank.Webpay.WebpayPlus.MallTransaction.new(
          Application.get_env(:rauversion, :tbk_mall_id),
          Application.get_env(:rauversion, :tbk_api_key),
          transbank_environment(event)
        )

      ccy = event.event_settings.ticket_currency
      total = Rauversion.PurchaseOrders.calculate_total(order, ccy)
      fee_amount = Rauversion.PurchaseOrders.calculate_fee(total, ccy)

      details = [
        %{
          amount: total,
          commerce_code: event.user.settings.tbk_commerce_code,
          buy_order: order.id
        },
        %{
          amount: fee_amount,
          commerce_code: Application.get_env(:rauversion, :tbk_commerce_id),
          buy_order: order.id
        }
      ]

      {:ok, %{details: details, trx: trx}}
    end)
    |> Multi.run(:gen_ticket, fn _repo,
                                 %{
                                   purchase_order: order,
                                   create_transaction: %{trx: trx, details: details}
                                 } ->
      session_id = "#{order.id}-#{user_id}"
      buy_order = "#{order.id}"

      return_url =
        RauversionWeb.Router.Helpers.tbk_url(
          RauversionWeb.Endpoint,
          :mall_events_commit,
          event.slug
        )

      {:ok, resp} =
        Transbank.Webpay.WebpayPlus.MallTransaction.create(
          trx,
          buy_order,
          session_id,
          return_url,
          details
        )

      case resp do
        %{"error_message" => err} ->
          IO.inspect(err)
          {:error, err}

        _ ->
          {:ok, %{response: resp, order: order}}
      end
    end)
    |> Repo.transaction()
  end

  def create_free_ticket_order(
        event,
        ticket_id,
        user_id
      ) do
    # IO.inspect(event)
    # IO.inspect(ticket_id)

    data = [%{"ticket_id" => ticket_id, "count" => 1}]

    Multi.new()
    |> Multi.insert(
      :purchase_order,
      PurchaseOrder.changeset(
        %PurchaseOrder{},
        %{
          "user_id" => user_id,
          "payment_id" => "e-#{event.id}-",
          "payment_provider" => "none"
        }
        |> Map.merge(%{"data" => data})
      )
    )
    |> Multi.run(:create_tickets, fn _repo, %{purchase_order: order} ->
      generate_purchased_tickets(order)
    end)
    |> Repo.transaction()
  end

  def notify_purchased_order(purchase_order, message \\ nil, inviter \\ nil, options \\ []) do
    defaults = [subject: nil, event: nil]
    options = Keyword.merge(defaults, options)

    Rauversion.Events.EventNotifier.deliver_event_tickets(
      purchase_order,
      message,
      inviter,
      options
    )
  end

  def notify_music_order_to_buyer(id) do
    order =
      Rauversion.PurchaseOrders.get_purchase_order!(id)
      |> Rauversion.Repo.preload([:albums, :tracks])

    case order do
      %PurchaseOrder{albums: [%Rauversion.Playlists.Playlist{} | _]} ->
        Rauversion.PurchaseOrders.MusicPurchaseNotifier.notify_album_purchase(order)

      %PurchaseOrder{tracks: [%Rauversion.Tracks.Track{} | _]} ->
        Rauversion.PurchaseOrders.MusicPurchaseNotifier.notify_tracks_purchase(order)

      _ ->
        nil
    end
  end

  def notify_music_order_to_author(id) do
    order =
      Rauversion.PurchaseOrders.get_purchase_order!(id)
      |> Rauversion.Repo.preload(albums: [:user], tracks: [:user])

    case order do
      %PurchaseOrder{albums: [%Rauversion.Playlists.Playlist{} | _]} ->
        Rauversion.PurchaseOrders.MusicPurchaseNotifier.notify_album_purchase_to_author(order)

      %PurchaseOrder{tracks: [%Rauversion.Tracks.Track{} | _]} ->
        Rauversion.PurchaseOrders.MusicPurchaseNotifier.notify_track_purchase_to_author(order)

      _ ->
        nil
    end
  end

  def notify_music_purchase(id) do
    %{order_id: id}
    |> Rauversion.Workers.OrderNotificationJob.new()
    |> Oban.insert()
  end
end
