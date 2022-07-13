defmodule Rauversion.Tracks do
  @moduledoc """
  The Tracks context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Tracks.Track

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Rauversion.PubSub, @topic)
  end

  def broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Rauversion.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  def broadcast_change({:error, result}, _event) do
    {:error, result}
  end

  def signed_id(track) do
    token = Phoenix.Token.sign(RauversionWeb.Endpoint, "user auth", track.id)
  end

  def find_by_signed_id!(token) do
    case Phoenix.Token.verify(RauversionWeb.Endpoint, "user auth", token, max_age: 86400) do
      {:ok, track_id} -> get_track!(track_id)
      _ -> nil
    end
  end

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """

  def list_tracks() do
    from p in Track,
      preload: [
        :mp3_audio_blob,
        :cover_blob,
        :cover_attachment,
        user: :avatar_attachment
      ]
  end

  def list_public_tracks() do
    from p in Track,
      where: p.private == false,
      preload: [
        :mp3_audio_blob,
        :cover_blob,
        :cover_attachment,
        user: :avatar_attachment
      ]
  end

  def list_tracks_by_username(user_id) do
    Rauversion.Accounts.get_user_by_username(user_id)
    |> Ecto.assoc(:tracks)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def preload_tracks_preloaded_by_user(query, current_user_id = %Rauversion.Accounts.User{id: id}) do
    likes_query =
      from pi in Rauversion.TrackLikes.TrackLike,
        where: pi.user_id == ^id

    reposts_query =
      from pi in Rauversion.Reposts.Repost,
        where: pi.user_id == ^id

    query
    |> Repo.preload(likes: likes_query, reposts: reposts_query)
  end

  def preload_tracks_preloaded_by_user(query, current_user_id = nil) do
    query
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

  def get_public_track!(id) do
    Track
    |> where(id: ^id)
    |> where([t], is_nil(t.private) or t.private == false)
    |> limit(1)
    |> Repo.one()
  end

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
    |> Track.new_changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:tracks, :created])
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
    |> broadcast_change([:tracks, :updated])
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
    |> broadcast_change([:tracks, :destroyed])
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

  def change_new_track(%Track{} = track, attrs \\ %{}) do
    Track.new_changeset(track, attrs)
  end

  def metadata(track, type) do
    case track do
      %{metadata: nil} ->
        nil

      %{metadata: metadata} ->
        metadata |> Map.get(type)

      _ ->
        nil
    end
  end

  # processes clip only for :local
  def reprocess_peaks(track) do
    blob = Rauversion.Tracks.blob_for(track, :audio)
    service = blob |> ActiveStorage.Blob.service()
    path = service.__struct__.path_for(service, blob.key)
    duration = blob |> ActiveStorage.Blob.metadata() |> Map.get("duration")

    data = Rauversion.Services.PeaksGenerator.run_audiowaveform(path, duration)
    # pass track.metadata.id is needed in order to merge the embedded_schema properly.
    update_track(track, %{metadata: %{id: track.metadata.id, peaks: data}})
  end

  defdelegate blob_url(user, kind), to: Rauversion.BlobUtils

  defdelegate blob_for(track, kind), to: Rauversion.BlobUtils

  defdelegate blob_proxy_url(user, kind), to: Rauversion.BlobUtils

  defdelegate variant_url(track, kind, options), to: Rauversion.BlobUtils

  defdelegate blob_url_for(track, kind), to: Rauversion.BlobUtils
end
