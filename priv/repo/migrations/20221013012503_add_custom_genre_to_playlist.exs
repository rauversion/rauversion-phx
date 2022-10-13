defmodule Rauversion.Repo.Migrations.AddCustomGenreToPlaylist do
  use Ecto.Migration

  def change do
    alter table(:playlists) do
      add :custom_genre, :string
    end
  end
end
