defmodule Rauversion.EventHosts do
  @moduledoc """
  The EventHosts context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.EventHosts.EventHost

  @doc """
  Returns the list of event_host.

  ## Examples

      iex> list_event_host()
      [%EventHost{}, ...]

  """
  def list_event_host do
    Repo.all(EventHost)
  end

  @doc """
  Gets a single event_host.

  Raises `Ecto.NoResultsError` if the Event host does not exist.

  ## Examples

      iex> get_event_host!(123)
      %EventHost{}

      iex> get_event_host!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_host!(id), do: Repo.get!(EventHost, id)

  @doc """
  Creates a event_host.

  ## Examples

      iex> create_event_host(%{field: value})
      {:ok, %EventHost{}}

      iex> create_event_host(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_host(attrs \\ %{}) do
    %EventHost{}
    |> EventHost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_host.

  ## Examples

      iex> update_event_host(event_host, %{field: new_value})
      {:ok, %EventHost{}}

      iex> update_event_host(event_host, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_host(%EventHost{} = event_host, attrs) do
    event_host
    |> EventHost.changeset(attrs)
    |> Rauversion.BlobUtils.process_one_upload(attrs, "avatar")
    |> Repo.update()
  end

  @doc """
  Deletes a event_host.

  ## Examples

      iex> delete_event_host(event_host)
      {:ok, %EventHost{}}

      iex> delete_event_host(event_host)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_host(%EventHost{} = event_host) do
    Repo.delete(event_host)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_host changes.

  ## Examples

      iex> change_event_host(event_host)
      %Ecto.Changeset{data: %EventHost{}}

  """
  def change_event_host(%EventHost{} = event_host, attrs \\ %{}) do
    EventHost.changeset(event_host, attrs)
  end
end
