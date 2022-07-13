defmodule Rauversion.TrackComments.TrackComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "track_comments" do
    field :body, :string
    field :state, :string
    field :track_minute, :integer
    # field :user_id, :id
    # field :track_id, :id

    belongs_to :user, Rauversion.Accounts.User
    belongs_to :track, Rauversion.Tracks.Track

    timestamps()
  end

  @doc false
  def changeset(track_comment, attrs) do
    track_comment
    |> cast(attrs, [:body, :track_minute, :state])
    |> validate_required([:body, :track_minute, :state])
  end
end
