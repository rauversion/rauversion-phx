defmodule Rauversion.Repo.Migrations.AddSettingsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :country, :string
      add :city, :string
      add :bio, :text
      add :support_link, :string
    end
  end
end
