defmodule Rauversion.Repo.Migrations.CreateOauthCredentials do
  use Ecto.Migration

  def change do
    create table(:oauth_credentials) do
      add :uid, :string
      add :token, :string, size: 3000
      add :data, :map
      add :provider, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:oauth_credentials, [:user_id])
    #  create index(:oauth_credentials, [:provider, :uid])
  end
end
