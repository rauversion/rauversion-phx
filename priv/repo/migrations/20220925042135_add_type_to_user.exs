defmodule Rauversion.Repo.Migrations.AddTypeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :type, :string, default: "user"
    end
  end
end
