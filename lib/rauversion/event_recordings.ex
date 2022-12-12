defmodule Rauversion.EventRecordings do
  @moduledoc """
  The EventRecordings context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.EventRecordings.EventRecording

  @doc """
  Returns the list of event_recordings.

  ## Examples

      iex> list_event_recordings()
      [%EventRecording{}, ...]

  """
  def list_event_recordings do
    Repo.all(EventRecording)
  end

  @doc """
  Gets a single event_recording.

  Raises `Ecto.NoResultsError` if the Event recording does not exist.

  ## Examples

      iex> get_event_recording!(123)
      %EventRecording{}

      iex> get_event_recording!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_recording!(id), do: Repo.get!(EventRecording, id)

  @doc """
  Creates a event_recording.

  ## Examples

      iex> create_event_recording(%{field: value})
      {:ok, %EventRecording{}}

      iex> create_event_recording(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_recording(attrs \\ %{}) do
    %EventRecording{}
    |> EventRecording.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_recording.

  ## Examples

      iex> update_event_recording(event_recording, %{field: new_value})
      {:ok, %EventRecording{}}

      iex> update_event_recording(event_recording, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_recording(%EventRecording{} = event_recording, attrs) do
    event_recording
    |> EventRecording.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event_recording.

  ## Examples

      iex> delete_event_recording(event_recording)
      {:ok, %EventRecording{}}

      iex> delete_event_recording(event_recording)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_recording(%EventRecording{} = event_recording) do
    Repo.delete(event_recording)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_recording changes.

  ## Examples

      iex> change_event_recording(event_recording)
      %Ecto.Changeset{data: %EventRecording{}}

  """
  def change_event_recording(%EventRecording{} = event_recording, attrs \\ %{}) do
    EventRecording.changeset(event_recording, attrs)
  end
end
