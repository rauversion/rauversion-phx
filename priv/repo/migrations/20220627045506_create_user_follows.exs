defmodule Rauversion.Repo.Migrations.CreateUserFollows do
  use Ecto.Migration

  def change do
    create table(:user_follows) do
      add :follower_id, references(:users, on_delete: :nothing)
      add :following_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_follows, [:follower_id])
    create index(:user_follows, [:following_id])
  end
end
