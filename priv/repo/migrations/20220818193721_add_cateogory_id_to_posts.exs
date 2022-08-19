defmodule Rauversion.Repo.Migrations.AddCateogoryIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :category_id, references(:categories, on_delete: :nothing)
    end
  end
end
