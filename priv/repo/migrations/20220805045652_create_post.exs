defmodule Rauversion.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :map
      add :settings, :map
      add :private, :boolean
      add :excerpt, :text
      add :slug, :string
      add :state, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:user_id])
  end
end
