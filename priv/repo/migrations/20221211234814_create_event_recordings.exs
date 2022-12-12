defmodule Rauversion.Repo.Migrations.CreateEventRecordings do
  use Ecto.Migration

  def change do
    create table(:event_recordings) do
      add :type, :string
      add :title, :string
      add :description, :text
      add :iframe, :text
      add :properties, :map
      add :position, :integer
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:event_recordings, [:event_id])
  end
end
