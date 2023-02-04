defmodule Rauversion.Repo.Migrations.AddTrackPurchaseOrderItems do
  use Ecto.Migration

  def change do
    create table(:track_purchase_orders) do
      add :purchase_order_id, references(:purchase_orders)
      add :track_id, references(:tracks)
      timestamps()
    end
  end
end
