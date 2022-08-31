defmodule Rauversion.EventTickets.EventTicket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_tickets" do
    field :early_bird_price, :decimal
    field :price, :decimal
    field :standard_price, :decimal
    field :qty, :integer
    field :selling_end, :utc_datetime
    field :selling_start, :utc_datetime
    field :short_description, :string
    field :title, :string
    # field :event_id, :id

    belongs_to :event, Rauversion.Events.Event
    embeds_one :settings, Rauversion.Events.Ticket, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(event_ticket, attrs) do
    event_ticket
    |> cast(attrs, [
      :title,
      :price,
      :early_bird_price,
      :standard_price,
      :qty,
      :selling_start,
      :selling_end,
      :short_description,
      :event_id
    ])
    |> cast_embed(:settings, with: &Rauversion.Events.Ticket.changeset/2)
    |> validate_required([
      :title,
      :price,
      # :early_bird_price,
      # :standard_price,
      :qty,
      :selling_start,
      :selling_end,
      :short_description,
      :settings
    ])
  end
end
