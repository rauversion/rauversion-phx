defmodule Rauversion.Playlists do
  @moduledoc """
  The Playlists context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Playlists.Playlist

  @doc """
  Returns the list of playlists.

  ## Examples

      iex> list_playlists()
      [%Playlist{}, ...]

  """
  def list_playlists do
    Repo.all(Playlist)
  end

  def list_playlists_by_user(user, _preloads = nil) do
    from pi in Playlist,
      where: pi.user_id == ^user.id
  end

  def list_playlists_by_user(user, _current_user = %Rauversion.Accounts.User{id: id}) do
    likes_query =
      from pi in Rauversion.PlaylistLikes.PlaylistLike,
        where: pi.user_id == ^id

    from pi in Playlist,
      where: pi.user_id == ^user.id,
      preload: [
        :user,
        likes: ^likes_query,
        track_playlists: [track: [:cover_blob, :mp3_audio_blob]]
      ]
  end

  def list_playlists_by_user_with_track(
        _track = %Rauversion.Tracks.Track{id: track_id},
        _current_user = %Rauversion.Accounts.User{id: user_id}
      ) do
    track_query =
      from pi in Rauversion.TrackPlaylists.TrackPlaylist,
        where: pi.track_id == ^track_id

    from pi in Playlist,
      where: pi.user_id == ^user_id,
      preload: [
        track_playlists: ^track_query
      ]
  end

  def list_public_playlists() do
    from p in Playlist,
      where: p.private == false,
      preload: [:user, :cover_blob]
  end

  def order_by_likes(query) do
    query |> order_by([p], desc: p.likes_count)
  end

  def get_public_playlist!(id) do
    Playlist
    |> where(id: ^id)
    |> where([t], is_nil(t.private) or t.private == false)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Gets a single playlist.

  Raises `Ecto.NoResultsError` if the Playlist does not exist.

  ## Examples

      iex> get_playlist!(123)
      %Playlist{}

      iex> get_playlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_playlist!(id), do: Repo.get!(Playlist, id)

  @doc """
  Creates a playlist.

  ## Examples

      iex> create_playlist(%{field: value})
      {:ok, %Playlist{}}

      iex> create_playlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playlist(attrs \\ %{}) do
    %Playlist{}
    |> Playlist.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:track_playlists)
    |> Repo.insert()
  end

  def preload_playlists_preloaded_by_user(_current_user = %Rauversion.Accounts.User{id: id}) do
    likes_query =
      from pi in Rauversion.PlaylistLikes.PlaylistLike,
        where: pi.user_id == ^id

    [likes: likes_query]
  end

  def preload_playlists_preloaded_by_user(query, _current_user_id = nil) do
    query
  end

  @doc """
  Updates a playlist.

  ## Examples

      iex> update_playlist(playlist, %{field: new_value})
      {:ok, %Playlist{}}

      iex> update_playlist(playlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_playlist(%Playlist{} = playlist, attrs) do
    playlist
    |> Playlist.changeset(attrs)
    |> Playlist.process_one_upload(attrs, "cover")
    |> Repo.update()
  end

  @doc """
  Deletes a playlist.

  ## Examples

      iex> delete_playlist(playlist)
      {:ok, %Playlist{}}

      iex> delete_playlist(playlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist(%Playlist{} = playlist) do
    Repo.delete(playlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist changes.

  ## Examples

      iex> change_playlist(playlist)
      %Ecto.Changeset{data: %Playlist{}}

  """
  def change_playlist(%Playlist{} = playlist, attrs \\ %{}) do
    Playlist.changeset(playlist, attrs)
  end

  def signed_id(playlist) do
    Phoenix.Token.sign(RauversionWeb.Endpoint, "user auth", playlist.id)
  end

  def find_by_signed_id!(token) do
    case Phoenix.Token.verify(RauversionWeb.Endpoint, "user auth", token, max_age: 86400) do
      {:ok, playlist_id} -> get_playlist!(playlist_id)
      _ -> nil
    end
  end

  defdelegate blob_url(user, kind), to: Rauversion.BlobUtils

  defdelegate blob_for(struct, kind), to: Rauversion.BlobUtils

  defdelegate blob_proxy_url(user, kind), to: Rauversion.BlobUtils

  defdelegate variant_url(struct, kind, options), to: Rauversion.BlobUtils

  defdelegate blob_url_for(struct, kind), to: Rauversion.BlobUtils
end
