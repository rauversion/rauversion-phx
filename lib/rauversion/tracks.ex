defmodule Rauversion.Tracks do
  @moduledoc """
  The Tracks context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Tracks.Track

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """

  def list_tracks(limit \\ 20) do
    Track |> limit(^limit) |> Repo.all()
  end

  def list_tracks_by_username(user_id) do
    Rauversion.Accounts.get_user_by_username(user_id)
    |> Ecto.assoc(:tracks)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single track.

  Raises `Ecto.NoResultsError` if the Track does not exist.

  ## Examples

      iex> get_track!(123)
      %Track{}

      iex> get_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track!(id), do: Repo.get!(Track, id)

  @doc """
  Creates a track.

  ## Examples

      iex> create_track(%{field: value})
      {:ok, %Track{}}

      iex> create_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track.

  ## Examples

      iex> update_track(track, %{field: new_value})
      {:ok, %Track{}}

      iex> update_track(track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track(%Track{} = track, attrs) do
    track
    |> Track.changeset(attrs)
    |> Track.process_one_upload(attrs, "cover")
    |> Track.process_one_upload(attrs, "audio")
    |> Repo.update()
  end

  @doc """
  Deletes a track.

  ## Examples

      iex> delete_track(track)
      {:ok, %Track{}}

      iex> delete_track(track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track changes.

  ## Examples

      iex> change_track(track)
      %Ecto.Changeset{data: %Track{}}

  """
  def change_track(%Track{} = track, attrs \\ %{}) do
    Track.changeset(track, attrs)
  end

  def blob_url(user, kind) do
    kind_blob = :"#{kind}_blob"

    # a = Rauversion.Accounts.get_user_by_username("michelson") |> Rauversion.Repo.preload(:avatar_blob)
    case user do
      nil ->
        nil

      %{^kind_blob => nil} ->
        nil

      %{^kind_blob => %ActiveStorage.Blob{} = blob} ->
        blob |> ActiveStorage.url()

      %{^kind_blob => %Ecto.Association.NotLoaded{}} ->
        user = user |> Rauversion.Repo.preload(kind_blob)

        apply(__MODULE__, :blob_url, [user, kind])
    end
  end

  def blob_for(track, kind) do
    kind_blob = :"#{kind}_blob"

    # a = Rauversion.Accounts.get_user_by_username("michelson") |> Rauversion.Repo.preload(:avatar_blob)
    case track do
      nil ->
        nil

      %{^kind_blob => nil} ->
        nil

      %{^kind_blob => %ActiveStorage.Blob{} = blob} ->
        blob

      %{^kind_blob => %Ecto.Association.NotLoaded{}} ->
        track = track |> Rauversion.Repo.preload(kind_blob)
        apply(__MODULE__, :blob_for, [track, kind])
    end
  end

  def variant_url(track, kind, options \\ %{resize_to_limit: "100x100"}) do
    blob_for(track, kind)
    |> ActiveStorage.Blob.Representable.variant(options)
    |> ActiveStorage.Variant.processed()
    |> ActiveStorage.Variant.url()
  end
end
