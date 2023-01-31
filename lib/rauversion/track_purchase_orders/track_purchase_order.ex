defmodule Rauversion.TrackPurchaseOrders.TrackPurchaseOrder do
  use Ecto.Schema

  schema "track_purchase_orders" do
    belongs_to :purchase_order, Rauversion.PurchaseOrders.PurchaseOrder
    belongs_to :track, Rauversion.Tracks.Track
    timestamps()
  end
end
