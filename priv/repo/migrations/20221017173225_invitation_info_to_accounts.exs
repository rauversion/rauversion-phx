defmodule Rauversion.Repo.Migrations.InvitationInfoToAccounts do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :invitations_count, :integer
      add :invited_by, references(:users, on_delete: :nothing)
    end

    create index(:users, [:invited_by])
  end
end
