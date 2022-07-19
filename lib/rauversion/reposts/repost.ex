defmodule Rauversion.Reposts.Repost do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reposts" do
    # field :user_id, :id
    # field :track_id, :id

    belongs_to(:user, Rauversion.Accounts.User)
    belongs_to(:track, Rauversion.Tracks.Track)

    timestamps()
  end

  @doc false
  def changeset(repost, attrs) do
    repost
    |> cast(attrs, [:user_id, :track_id])
    |> validate_required([:user_id, :track_id])
    |> prepare_changes(fn changeset ->
      Ecto.assoc(changeset.data, :track)
      |> Rauversion.Repo.update_all(inc: [reposts_count: 1])

      changeset
    end)
  end
end
