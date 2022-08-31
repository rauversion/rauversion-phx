defmodule Rauversion.PurchasedTickets.PurchasedTicket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchased_tickets" do
    field :data, :map
    field :state, :string
    belongs_to :user, Rauversion.Accounts.User
    belongs_to :event_ticket, Rauversion.EventTickets.EventTicket
    timestamps()
  end

  @doc false
  def changeset(purchased_ticket, attrs) do
    purchased_ticket
    |> cast(attrs, [:state, :data, :event_ticket_id, :user_id])
    |> validate_required([:state, :data, :event_ticket_id, :user_id])
  end
end
