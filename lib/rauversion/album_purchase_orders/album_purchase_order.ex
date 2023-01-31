defmodule Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder do
  use Ecto.Schema

  schema "album_purchase_orders" do
    belongs_to :purchase_order, Rauversion.PurchaseOrders.PurchaseOrder
    belongs_to :playlist, Rauversion.Playlists.Playlist
    timestamps()
  end
end
