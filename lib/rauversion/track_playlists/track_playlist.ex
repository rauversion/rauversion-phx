defmodule Rauversion.TrackPlaylists.TrackPlaylist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "track_playlists" do
    # field :track_id, :id
    # field :playlist, :id
    belongs_to :playlist, Rauversion.Playlists.Playlist
    belongs_to :track, Rauversion.Tracks.Track

    timestamps()
  end

  def record_type() do
    "Playlist"
  end

  @doc false
  def changeset(track_playlist, attrs) do
    track_playlist
    |> cast(attrs, [:playlist_id, :track_id])
    |> validate_required([:playlist_id, :track_id])
  end
end
