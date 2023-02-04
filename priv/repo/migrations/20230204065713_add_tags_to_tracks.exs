defmodule Rauversion.Repo.Migrations.AddTagsToTracks do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add :tags, {:array, :string}
    end

    execute("create index tracks_tags_index on tracks using gin (tags);")
  end
end
