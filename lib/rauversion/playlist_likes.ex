defmodule Rauversion.PlaylistLikes do
  @moduledoc """
  The PlaylistLikes context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.PlaylistLikes.PlaylistLike

  @doc """
  Returns the list of playlist_likes.

  ## Examples

      iex> list_playlist_likes()
      [%PlaylistLike{}, ...]

  """
  def list_playlist_likes do
    Repo.all(PlaylistLike)
  end

  @doc """
  Gets a single playlist_like.

  Raises `Ecto.NoResultsError` if the Playlist like does not exist.

  ## Examples

      iex> get_playlist_like!(123)
      %PlaylistLike{}

      iex> get_playlist_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_playlist_like!(id), do: Repo.get!(PlaylistLike, id)

  @doc """
  Creates a playlist_like.

  ## Examples

      iex> create_playlist_like(%{field: value})
      {:ok, %PlaylistLike{}}

      iex> create_playlist_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playlist_like(attrs \\ %{}) do
    case Ecto.Multi.new()
         |> Ecto.Multi.insert(:playlist_like, %PlaylistLike{} |> PlaylistLike.changeset(attrs))
         |> Ecto.Multi.run(:counters, fn _repo, %{playlist_like: playlist_like} ->
           from(t in Rauversion.Playlists.Playlist,
             where: t.id == ^playlist_like.playlist_id
           )
           |> Repo.update_all(inc: [likes_count: 1])

           {:ok, nil}
         end)
         |> Repo.transaction() do
      {:ok, %{counters: _, playlist_like: track_like}} -> {:ok, track_like}
      err -> err
    end
  end

  @doc """
  Updates a playlist_like.

  ## Examples

      iex> update_playlist_like(playlist_like, %{field: new_value})
      {:ok, %PlaylistLike{}}

      iex> update_playlist_like(playlist_like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_playlist_like(%PlaylistLike{} = playlist_like, attrs) do
    playlist_like
    |> PlaylistLike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a playlist_like.

  ## Examples

      iex> delete_playlist_like(playlist_like)
      {:ok, %PlaylistLike{}}

      iex> delete_playlist_like(playlist_like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist_like(%PlaylistLike{} = playlist_like) do
    res = Repo.delete(playlist_like)

    Ecto.assoc(playlist_like, :playlist)
    |> Rauversion.Repo.update_all(inc: [likes_count: -1])

    res
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist_like changes.

  ## Examples

      iex> change_playlist_like(playlist_like)
      %Ecto.Changeset{data: %PlaylistLike{}}

  """
  def change_playlist_like(%PlaylistLike{} = playlist_like, attrs \\ %{}) do
    PlaylistLike.changeset(playlist_like, attrs)
  end
end
