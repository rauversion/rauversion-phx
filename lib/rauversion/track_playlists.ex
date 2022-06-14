defmodule Rauversion.TrackPlaylists do
  @moduledoc """
  The TrackPlaylists context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.TrackPlaylists.TrackPlaylist

  @doc """
  Returns the list of track_playlists.

  ## Examples

      iex> list_track_playlists()
      [%TrackPlaylist{}, ...]

  """
  def list_track_playlists do
    Repo.all(TrackPlaylist)
  end

  @doc """
  Gets a single track_playlist.

  Raises `Ecto.NoResultsError` if the Track playlist does not exist.

  ## Examples

      iex> get_track_playlist!(123)
      %TrackPlaylist{}

      iex> get_track_playlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track_playlist!(id), do: Repo.get!(TrackPlaylist, id)

  @doc """
  Creates a track_playlist.

  ## Examples

      iex> create_track_playlist(%{field: value})
      {:ok, %TrackPlaylist{}}

      iex> create_track_playlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track_playlist(attrs \\ %{}) do
    %TrackPlaylist{}
    |> TrackPlaylist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track_playlist.

  ## Examples

      iex> update_track_playlist(track_playlist, %{field: new_value})
      {:ok, %TrackPlaylist{}}

      iex> update_track_playlist(track_playlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track_playlist(%TrackPlaylist{} = track_playlist, attrs) do
    track_playlist
    |> TrackPlaylist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track_playlist.

  ## Examples

      iex> delete_track_playlist(track_playlist)
      {:ok, %TrackPlaylist{}}

      iex> delete_track_playlist(track_playlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track_playlist(%TrackPlaylist{} = track_playlist) do
    Repo.delete(track_playlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track_playlist changes.

  ## Examples

      iex> change_track_playlist(track_playlist)
      %Ecto.Changeset{data: %TrackPlaylist{}}

  """
  def change_track_playlist(%TrackPlaylist{} = track_playlist, attrs \\ %{}) do
    TrackPlaylist.changeset(track_playlist, attrs)
  end
end
