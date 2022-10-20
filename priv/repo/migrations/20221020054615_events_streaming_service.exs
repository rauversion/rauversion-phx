defmodule Rauversion.Repo.Migrations.EventsStreamingService do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :streaming_service, :map
    end
  end
end
