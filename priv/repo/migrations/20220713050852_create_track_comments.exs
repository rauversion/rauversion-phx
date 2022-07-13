defmodule Rauversion.Repo.Migrations.CreateTrackComments do
  use Ecto.Migration

  def change do
    create table(:track_comments) do
      add :body, :text
      add :track_minute, :integer
      add :state, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :track_id, references(:tracks, on_delete: :nothing)

      timestamps()
    end

    create index(:track_comments, [:user_id])
    create index(:track_comments, [:track_id])
  end
end
