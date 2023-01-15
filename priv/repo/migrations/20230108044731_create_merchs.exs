defmodule Rauversion.Repo.Migrations.CreateMerchs do
  use Ecto.Migration

  def change do
    create table(:merchs) do
      add :title, :string
      add :description, :string
      add :pricing, :decimal
      add :shipping_data, :map
      add :qty, :integer
      add :private, :boolean, default: false, null: false
      add :options, :map
      add :type, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :album_id, references(:playlists, on_delete: :nothing)

      timestamps()
    end

    create index(:merchs, [:user_id])
    create index(:merchs, [:album_id])
  end
end
