defmodule Rauversion.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:preview_cards) do
      add :url, :string
      add :title, :string
      add :description, :text
      add :type, :string
      add :author_name, :string
      add :author_url, :string
      add :html, :string
      add :image, :text

      timestamps()
    end
  end
end
