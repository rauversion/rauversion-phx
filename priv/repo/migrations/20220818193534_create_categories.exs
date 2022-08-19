defmodule Rauversion.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :slug, :string

      timestamps()
    end
  end
end
