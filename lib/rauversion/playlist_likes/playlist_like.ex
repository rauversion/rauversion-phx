defmodule Rauversion.PlaylistLikes.PlaylistLike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlist_likes" do
    belongs_to :user, Rauversion.Accounts.User
    belongs_to :playlist, Rauversion.Playlists.Playlist
    timestamps()
  end

  @doc false
  def changeset(playlist_like, attrs) do
    playlist_like
    |> cast(attrs, [])
    |> validate_required([])
  end
end
