defmodule Rauversion.TrackComments do
  @moduledoc """
  The TrackComments context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.TrackComments.TrackComment

  @doc """
  Returns the list of track_comments.

  ## Examples

      iex> list_track_comments()
      [%TrackComment{}, ...]

  """
  def list_track_comments do
    Repo.all(TrackComment)
  end

  @doc """
  Gets a single track_comment.

  Raises `Ecto.NoResultsError` if the Track comment does not exist.

  ## Examples

      iex> get_track_comment!(123)
      %TrackComment{}

      iex> get_track_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track_comment!(id), do: Repo.get!(TrackComment, id)

  @doc """
  Creates a track_comment.

  ## Examples

      iex> create_track_comment(%{field: value})
      {:ok, %TrackComment{}}

      iex> create_track_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track_comment(attrs \\ %{}) do
    %TrackComment{}
    |> TrackComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track_comment.

  ## Examples

      iex> update_track_comment(track_comment, %{field: new_value})
      {:ok, %TrackComment{}}

      iex> update_track_comment(track_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track_comment(%TrackComment{} = track_comment, attrs) do
    track_comment
    |> TrackComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track_comment.

  ## Examples

      iex> delete_track_comment(track_comment)
      {:ok, %TrackComment{}}

      iex> delete_track_comment(track_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track_comment(%TrackComment{} = track_comment) do
    Repo.delete(track_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track_comment changes.

  ## Examples

      iex> change_track_comment(track_comment)
      %Ecto.Changeset{data: %TrackComment{}}

  """
  def change_track_comment(%TrackComment{} = track_comment, attrs \\ %{}) do
    TrackComment.changeset(track_comment, attrs)
  end
end
