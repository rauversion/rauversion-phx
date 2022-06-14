defmodule Rauversion.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string
      add :notification_settings, :map
      add :settings, :map
    end
  end
end
