defmodule Rauversion.EventTickets do
  @moduledoc """
  The EventTickets context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.EventTickets.EventTicket

  @doc """
  Returns the list of event_tickets.

  ## Examples

      iex> list_event_tickets()
      [%EventTicket{}, ...]

  """
  def list_event_tickets do
    Repo.all(EventTicket)
  end

  @doc """
  Gets a single event_ticket.

  Raises `Ecto.NoResultsError` if the Event ticket does not exist.

  ## Examples

      iex> get_event_ticket!(123)
      %EventTicket{}

      iex> get_event_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_ticket!(id), do: Repo.get!(EventTicket, id)

  @doc """
  Creates a event_ticket.

  ## Examples

      iex> create_event_ticket(%{field: value})
      {:ok, %EventTicket{}}

      iex> create_event_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_ticket(attrs \\ %{}) do
    %EventTicket{}
    |> EventTicket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_ticket.

  ## Examples

      iex> update_event_ticket(event_ticket, %{field: new_value})
      {:ok, %EventTicket{}}

      iex> update_event_ticket(event_ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_ticket(%EventTicket{} = event_ticket, attrs) do
    event_ticket
    |> EventTicket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event_ticket.

  ## Examples

      iex> delete_event_ticket(event_ticket)
      {:ok, %EventTicket{}}

      iex> delete_event_ticket(event_ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_ticket(%EventTicket{} = event_ticket) do
    Repo.delete(event_ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_ticket changes.

  ## Examples

      iex> change_event_ticket(event_ticket)
      %Ecto.Changeset{data: %EventTicket{}}

  """
  def change_event_ticket(%EventTicket{} = event_ticket, attrs \\ %{}) do
    EventTicket.changeset(event_ticket, attrs)
  end
end
