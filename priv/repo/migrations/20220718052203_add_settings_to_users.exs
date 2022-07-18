defmodule Rauversion.Repo.Migrations.AddSettingsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :notification_preferences, :map
      add :country, :string
      add :city, :string
      add :bio, :text
    end
  end
end
