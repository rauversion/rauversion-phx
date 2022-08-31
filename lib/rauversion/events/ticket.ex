defmodule Rauversion.Events.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :show_sell_until, :boolean
    field :show_after_sold_out, :boolean
    field :fee_type, :string
    field :hidden, :boolean
    field :max_tickets_per_order, :integer
    field :min_tickets_per_order, :integer
    field :sales_channel, :string
    field :after_purchase_message, :string
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [
      :show_sell_until,
      :show_after_sold_out,
      :fee_type,
      :hidden,
      :max_tickets_per_order,
      :min_tickets_per_order,
      :sales_channel,
      :after_purchase_message
    ])
    |> validate_required([])
  end
end
