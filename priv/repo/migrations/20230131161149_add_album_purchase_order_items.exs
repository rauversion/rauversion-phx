defmodule Rauversion.Repo.Migrations.AddAlbumPurchaseOrderItems do
  use Ecto.Migration

  def change do
    create table(:album_purchase_orders) do
      add :purchase_order_id, references(:purchase_orders)
      add :playlist_id, references(:playlists)
      timestamps()
    end
  end
end
