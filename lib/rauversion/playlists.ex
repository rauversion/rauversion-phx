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

  def list_playlists_by_user(user) do
    user |> Ecto.assoc(:playlists)
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

  def create_playlist_from_hash(attrs \\ %{}) do
    # %Playlist{}
    # |> Playlist.changeset(attrs)
    # |> Ecto.Changeset.cast_assoc(:track_playlists)
    # |> Repo.insert()

    alias Ecto.Multi

    Multi.new()
    |> Multi.insert(:playlist, Playlist.changeset(%Playlist{}, attrs))
    |> Multi.run(:playlist_with_tracks, fn _, %{playlist: playlist} ->
      # handles from params (stringy keys or from symbolized keys) ugly!

      case attrs do
        %{"track_playlists" => track_playlists} ->
          track_playlists =
            track_playlists
            |> Enum.map(fn x ->
              %{playlist_id: playlist.id, track_id: x["track_id"] |> String.to_integer()}
            end)

          Playlist.changeset(playlist |> Repo.preload([:track_playlists, :user]), %{})
          |> Ecto.Changeset.put_assoc(:track_playlists, track_playlists)
          |> Repo.update()

        %{track_playlists: track_playlists} ->
          track_playlists =
            track_playlists
            |> Enum.map(fn x ->
              %{playlist_id: playlist.id, track_id: x.track_id}
            end)

          Playlist.changeset(playlist |> Repo.preload([:track_playlists, :user]), %{})
          |> Ecto.Changeset.put_assoc(:track_playlists, track_playlists)
          |> Repo.update()

        _ ->
          {:ok, playlist |> Repo.preload([:track_playlists, :user])}
      end

      # UsersProfiles.create_user_profile_owner(%{user_id: user.id, profile_id: id})
    end)
    |> Repo.transaction()
  end

  def preload_playlists_preloaded_by_user(
        query,
        _current_user = %Rauversion.Accounts.User{id: id}
      ) do
    likes_query =
      from pi in Rauversion.PlaylistLikes.PlaylistLike,
        where: pi.user_id == ^id

    query
    |> Repo.preload(likes: likes_query)
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

  defdelegate blob_url(user, kind), to: Rauversion.BlobUtils

  defdelegate blob_for(struct, kind), to: Rauversion.BlobUtils

  defdelegate blob_proxy_url(user, kind), to: Rauversion.BlobUtils

  defdelegate variant_url(struct, kind, options), to: Rauversion.BlobUtils

  defdelegate blob_url_for(struct, kind), to: Rauversion.BlobUtils
end
