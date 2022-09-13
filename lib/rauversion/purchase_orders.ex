defmodule Rauversion.PurchaseOrders do
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

  def calculate_total(order) do
    order.data
    |> Enum.filter(fn x -> x.count != 0 end)
    |> Enum.map(fn x ->
      ticket = Rauversion.EventTickets.get_event_ticket!(x.ticket_id)
      Decimal.to_float(ticket.price) * x.count
    end)
    |> Enum.sum()
  end

  def create_stripe_session(order, event) do
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

    Rauversion.Stripe.Client.create_session(
      client,
      c.uid,
      %{
        "line_items" => line_items,
        "payment_intent_data" => %{
          "application_fee_amount" => 100
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

  def generate_purchased_tickets(order) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:purchased_tickets, fn _repo, _ ->
      purchased_tickets =
        order.data
        |> Enum.map(fn ticket ->
          Enum.to_list(1..ticket.count)
          |> Enum.map(fn _ ->
            Rauversion.PurchasedTickets.create_purchased_ticket(%{
              "user_id" => order.user_id,
              "purchase_order_id" => order.id,
              "event_ticket_id" => ticket.ticket_id,
              "state" => "paid"
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
        true -> {:error, nil}
        false -> {:ok, nil}
      end
    end)
    |> Repo.transaction()
  end
end
