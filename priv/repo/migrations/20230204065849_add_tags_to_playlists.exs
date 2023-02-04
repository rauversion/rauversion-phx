defmodule Rauversion.Repo.Migrations.AddTagsToPlaylists do
  use Ecto.Migration

  def change do
    alter table(:playlists) do
      add :tags, {:array, :string}
    end

    execute("create index playlists_tags_index on playlists using gin (tags);")
  end
end
