defmodule Rauversion.PurchasedTickets.PurchasedTicket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchased_tickets" do
    field :state, :string, default: "pending"
    field :checked_in, :boolean
    field :checked_in_at, :utc_datetime
    belongs_to :purchase_order, Rauversion.PurchaseOrders.PurchaseOrder
    belongs_to :user, Rauversion.Accounts.User
    belongs_to :event_ticket, Rauversion.EventTickets.EventTicket
    embeds_one :data, Rauversion.PurchasedTickets.PurchasedTicketData, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(purchased_ticket, attrs) do
    purchased_ticket
    |> cast(attrs, [:state, :event_ticket_id, :user_id, :purchase_order_id])
    |> cast_embed(:data,
      with: &Rauversion.PurchasedTickets.PurchasedTicketData.changeset/2
    )
    |> validate_required([:state, :event_ticket_id, :user_id, :purchase_order_id])
  end

  def check_in_changeset(purchased_ticket, attrs) do
    purchased_ticket
    |> cast(attrs, [:checked_in, :checked_in_at])
    |> validate_required([:checked_in, :checked_in_at])
  end

  def uncheck_in_changeset(purchased_ticket, attrs) do
    purchased_ticket
    |> cast(attrs, [:checked_in, :checked_in_at])
    |> validate_required([])
  end
end

defmodule Rauversion.PurchasedTickets.PurchasedTicketData do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :price, :decimal
  end

  @required_fields []
  @optional_fields [
    :price
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
