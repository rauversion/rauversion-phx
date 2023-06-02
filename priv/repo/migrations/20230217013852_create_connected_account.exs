defmodule Rauversion.Repo.Migrations.CreateConnectedAccount do
  use Ecto.Migration

  def change do
    create table(:connected_accounts) do
      add :state, :string
      add :parent_id, references(:users, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:connected_accounts, [:parent_id])
    create index(:connected_accounts, [:user_id])
  end
end
