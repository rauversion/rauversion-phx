defmodule Rauversion.Repo.Migrations.CreateTrackLikes do
  use Ecto.Migration

  def change do
    create table(:track_likes) do
      add :user_id, references(:users, on_delete: :nothing)
      add :track_id, references(:tracks, on_delete: :nothing)

      timestamps()
    end

    create index(:track_likes, [:user_id])
    create index(:track_likes, [:track_id])
  end
end
