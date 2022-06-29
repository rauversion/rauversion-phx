defmodule Rauversion.TrackLikes do
  @moduledoc """
  The TrackLikes context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.TrackLikes.TrackLike

  @doc """
  Returns the list of track_likes.

  ## Examples

      iex> list_track_likes()
      [%TrackLike{}, ...]

  """
  def list_track_likes do
    Repo.all(TrackLike)
  end

  @doc """
  Gets a single track_like.

  Raises `Ecto.NoResultsError` if the Track like does not exist.

  ## Examples

      iex> get_track_like!(123)
      %TrackLike{}

      iex> get_track_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track_like!(id), do: Repo.get!(TrackLike, id)

  @doc """
  Creates a track_like.

  ## Examples

      iex> create_track_like(%{field: value})
      {:ok, %TrackLike{}}

      iex> create_track_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track_like(attrs \\ %{}) do
    %TrackLike{}
    |> TrackLike.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track_like.

  ## Examples

      iex> update_track_like(track_like, %{field: new_value})
      {:ok, %TrackLike{}}

      iex> update_track_like(track_like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track_like(%TrackLike{} = track_like, attrs) do
    track_like
    |> TrackLike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track_like.

  ## Examples

      iex> delete_track_like(track_like)
      {:ok, %TrackLike{}}

      iex> delete_track_like(track_like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track_like(%TrackLike{} = track_like) do
    Repo.delete(track_like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track_like changes.

  ## Examples

      iex> change_track_like(track_like)
      %Ecto.Changeset{data: %TrackLike{}}

  """
  def change_track_like(%TrackLike{} = track_like, attrs \\ %{}) do
    TrackLike.changeset(track_like, attrs)
  end
end
