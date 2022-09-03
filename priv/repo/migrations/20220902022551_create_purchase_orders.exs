defmodule Rauversion.Repo.Migrations.CreatePurchaseOrders do
  use Ecto.Migration

  def change do
    create table(:purchase_orders) do
      add :total, :decimal
      add :promo_code, :string
      add :data, :map
      add :state, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:purchase_orders, [:user_id])
  end
end
