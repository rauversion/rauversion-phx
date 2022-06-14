defmodule Rauversion.Repo.Migrations.CreatePlaylists do
  use Ecto.Migration

  def change do
    create table(:playlists) do
      add :slug, :string
      add :description, :text
      add :title, :string
      add :metadata, :map
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:playlists, [:user_id])
  end
end
