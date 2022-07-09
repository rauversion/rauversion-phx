defmodule Rauversion.Repo.Migrations.CreatePlaylistLikes do
  use Ecto.Migration

  def change do
    create table(:playlist_likes) do
      add :user_id, references(:users, on_delete: :nothing)
      add :playlist_id, references(:playlists, on_delete: :nothing)

      timestamps()
    end

    create index(:playlist_likes, [:user_id])
    create index(:playlist_likes, [:playlist_id])
  end
end
