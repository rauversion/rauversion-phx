defmodule Rauversion.Repo.Migrations.AddIsLabelToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :label, :boolean
    end
  end
end
