defmodule Rauversion.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :price, :decimal
    field :include_message, :boolean
    field :optional_message, :string
    field :initial_price, :decimal
  end

  @required_fields []
  @optional_fields [
    :include_message,
    :optional_message,
    :initial_price,
    :price
  ]

  def change(%__MODULE__{} = payment, attrs) do
    payment
    |> __MODULE__.changeset(attrs)
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_pricing_bounds()
    |> optional_required()
  end

  def optional_required(changeset) do
    if get_field(changeset, :include_message) do
      val = get_field(changeset, :optional_message)

      if is_nil(val) || String.trim(val) == "" do
        add_error(changeset, :optional_message, "empty message")
      else
        changeset
      end
    else
      changeset
    end
  end

  # when is_atom(field) do
  def validate_pricing_bounds(changeset) do
    validate_change(changeset, :price, fn _f, count ->
      max = get_field(changeset, :initial_price)

      formatted = Number.Currency.number_to_currency(max, precision: 2)

      cond do
        count.coef < max.coef ->
          [{:price, "Min Price should be #{formatted}"}]

        true ->
          []
      end
    end)
  end

  def get_price(payment_price, fee) do
    ((Decimal.to_integer(payment_price) + fee) * 100)
    |> round
  end

  def create_stripe_session(payment, album, changeset) do
    client = Rauversion.Stripe.Client.new()
    user = album |> Ecto.assoc(:user) |> Rauversion.Repo.one()

    payment_price = changeset.price || changeset.initial_price

    c =
      case Rauversion.Accounts.get_oauth_credential(user, "stripe") do
        nil ->
          _fee = Rauversion.PurchaseOrders.calculate_fee(payment_price, "usd")

          %{cid: nil, data: %{}, price: Decimal.to_integer(payment_price) * 100}

        data ->
          %{
            cid: data.uid,
            price: Decimal.to_integer(payment_price) * 100,
            data: %{
              "application_fee_amount" => round(Rauversion.PurchaseOrders.app_fee())
              # "transfer_data" => %{
              #  "destination" => data.uid
              # }
            }
          }
      end

    line_items =
      [%{}]
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {x, i}, acc ->
        acc
        |> Map.merge(%{
          "#{i}" => %{
            "quantity" => 1,
            "price_data" => %{
              "unit_amount" => c.price,
              "currency" => "USD",
              "product_data" => %{
                "name" => album.title,
                "description" => description_by_resource(album)
              }
            }
          }
        })
      end)

    IO.inspect(line_items)

    create_session_by_resouce(album, client, c.cid, line_items, c)
  end

  def description_by_resource(resource = %Rauversion.Playlists.Playlist{}) do
    "Buy digital album #{resource.title} from #{resource.user.username}"
  end

  def description_by_resource(resource = %Rauversion.Tracks.Track{}) do
    "Buy digital song #{resource.title} from #{resource.user.username}"
  end

  def create_session_by_resouce(
        resource = %Rauversion.Playlists.Playlist{},
        client,
        cid,
        line_items,
        c
      ) do
    Rauversion.Stripe.Client.create_session(
      client,
      cid,
      %{
        "line_items" => line_items,
        "payment_intent_data" => c.data,
        "mode" => "payment",
        "success_url" =>
          RauversionWeb.Router.Helpers.playlist_show_url(
            RauversionWeb.Endpoint,
            :payment_success,
            resource.slug
          ),
        "cancel_url" =>
          RauversionWeb.Router.Helpers.playlist_show_url(
            RauversionWeb.Endpoint,
            :payment_cancel,
            resource.slug
          )
      }
    )
  end

  def create_session_by_resouce(resource = %Rauversion.Tracks.Track{}, client, cid, line_items, c) do
    Rauversion.Stripe.Client.create_session(
      client,
      cid,
      %{
        "line_items" => line_items,
        "payment_intent_data" => c.data,
        "mode" => "payment",
        "success_url" =>
          RauversionWeb.Router.Helpers.track_show_url(
            RauversionWeb.Endpoint,
            :payment_success,
            resource.slug
          ),
        "cancel_url" =>
          RauversionWeb.Router.Helpers.track_show_url(
            RauversionWeb.Endpoint,
            :payment_cancel,
            resource.slug
          )
      }
    )
  end

  # free access
  def create_with_purchase_order(
        album,
        _payment = %{initial_price: initial_price, price: price},
        current_user
      )
      when initial_price.coef == 0 and (is_nil(price) or price.coef == 0) do
    {:ok, a} = create_purchase_order_by_resource(album, current_user.id)

    {:ok, order} =
      Rauversion.PurchaseOrders.update_purchase_order(a, %{
        "payment_provider" => "free",
        "total" => 0,
        "state" => "free_access"
      })

    {:ok, %{resp: %{free: true}, order: order}}
  end

  def create_with_purchase_order(album, payment, current_user) do
    {:ok, a} = create_purchase_order_by_resource(album, current_user.id)

    {:ok, data} =
      __MODULE__.create_stripe_session(
        a,
        album,
        payment
      )

    {:ok, order_with_payment_id} =
      Rauversion.PurchaseOrders.update_purchase_order(a, %{
        "payment_id" => data["id"],
        "payment_provider" => "stripe",
        "total" => payment.price
      })

    {:ok, %{resp: data, order: order_with_payment_id}}
  end

  def create_purchase_order_by_resource(resource = %Rauversion.Playlists.Playlist{}, user_id) do
    Rauversion.PurchaseOrders.create_purchase_order(%{
      "user_id" => user_id,
      "albums" => [resource]
    })
  end

  def create_purchase_order_by_resource(resource = %Rauversion.Tracks.Track{}, user_id) do
    Rauversion.PurchaseOrders.create_purchase_order(%{
      "user_id" => user_id,
      "tracks" => [resource]
    })
  end
end
