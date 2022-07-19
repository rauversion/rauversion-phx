defmodule Rauversion.TrackLikes.TrackLike do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "track_likes" do
    # field :user_id, :id
    # field :track_id, :id

    belongs_to :user, Rauversion.Accounts.User
    belongs_to :track, Rauversion.Tracks.Track

    timestamps()
  end

  @doc false
  def changeset(track_like, attrs) do
    track_like
    |> cast(attrs, [:track_id, :user_id])
    |> validate_required([:track_id, :user_id])
  end
end
