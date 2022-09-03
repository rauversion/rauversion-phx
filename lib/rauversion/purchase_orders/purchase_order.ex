defmodule Rauversion.PurchaseOrders.PurchaseOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchase_orders" do
    field :promo_code, :string
    field :total, :decimal
    # field :data, :map
    field :payment_id, :string
    field :payment_provider, :string

    embeds_many :data, Rauversion.PurchaseOrders.PurchaseOrderTickets, on_replace: :delete
    belongs_to :user, Rauversion.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(purchase_order, attrs) do
    purchase_order
    |> cast(attrs, [:total, :promo_code, :user_id, :payment_id, :payment_provider])
    |> cast_embed(:data, with: &Rauversion.PurchaseOrders.PurchaseOrderTickets.changeset/2)
    |> validate_required([:user_id])
  end
end

defmodule Rauversion.PurchaseOrders.PurchaseOrderTickets do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :ticket_id, :integer
    field :count, :integer
  end

  @required_fields []
  @optional_fields [:ticket_id, :count]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    # |> validate_number(:count, greater_than: 0)
    |> validate_is_ticket_count_bounds(:count)
  end

  # when is_atom(field) do
  def validate_is_ticket_count_bounds(changeset, field) do
    validate_change(changeset, field, fn _f, count ->
      ticket = Rauversion.EventTickets.get_event_ticket!(changeset.changes.ticket_id)

      max = ticket.settings.max_tickets_per_order
      min = ticket.settings.min_tickets_per_order

      cond do
        is_number(max) && count > max && count != 0 ->
          [{field, "max tickets"}]

        is_number(min) && count < min && count != 0 ->
          [{field, "min tickets"}]

        true ->
          []
      end

      # case String.starts_with?(url, @our_url) do
      #  true -> []
      #  false -> [{field, options[:message] || "Unexpected URL"}]
      # end
    end)
  end
end
