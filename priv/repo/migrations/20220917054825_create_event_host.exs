defmodule Rauversion.Repo.Migrations.CreateEventHost do
  use Ecto.Migration

  def change do
    create table(:event_host) do
      add :name, :string
      add :description, :text
      add :event_id, references(:events, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :listed_on_page, :boolean
      add :event_manager, :boolean
      timestamps()
    end

    create index(:event_host, [:event_id])
    create index(:event_host, [:user_id])
  end
end
