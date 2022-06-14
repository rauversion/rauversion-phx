defmodule Rauversion.Repo.Migrations.CreateReposts do
  use Ecto.Migration

  def change do
    create table(:reposts) do
      add :user_id, references(:users, on_delete: :nothing)
      add :track_id, references(:tracks, on_delete: :nothing)

      timestamps()
    end

    create index(:reposts, [:user_id])
    create index(:reposts, [:track_id])
  end
end
