defmodule Rauversion.PurchasedTickets do
  @moduledoc """
  The PurchasedTickets context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.PurchasedTickets.PurchasedTicket

  @doc """
  Returns the list of purchased_tickets.

  ## Examples

      iex> list_purchased_tickets()
      [%PurchasedTicket{}, ...]

  """
  def list_purchased_tickets do
    Repo.all(PurchasedTicket)
  end

  @doc """
  Gets a single purchased_ticket.

  Raises `Ecto.NoResultsError` if the Purchased ticket does not exist.

  ## Examples

      iex> get_purchased_ticket!(123)
      %PurchasedTicket{}

      iex> get_purchased_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_purchased_ticket!(id), do: Repo.get!(PurchasedTicket, id)

  @doc """
  Creates a purchased_ticket.

  ## Examples

      iex> create_purchased_ticket(%{field: value})
      {:ok, %PurchasedTicket{}}

      iex> create_purchased_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_purchased_ticket(attrs \\ %{}) do
    %PurchasedTicket{}
    |> PurchasedTicket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a purchased_ticket.

  ## Examples

      iex> update_purchased_ticket(purchased_ticket, %{field: new_value})
      {:ok, %PurchasedTicket{}}

      iex> update_purchased_ticket(purchased_ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_purchased_ticket(%PurchasedTicket{} = purchased_ticket, attrs) do
    purchased_ticket
    |> PurchasedTicket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a purchased_ticket.

  ## Examples

      iex> delete_purchased_ticket(purchased_ticket)
      {:ok, %PurchasedTicket{}}

      iex> delete_purchased_ticket(purchased_ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_purchased_ticket(%PurchasedTicket{} = purchased_ticket) do
    Repo.delete(purchased_ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking purchased_ticket changes.

  ## Examples

      iex> change_purchased_ticket(purchased_ticket)
      %Ecto.Changeset{data: %PurchasedTicket{}}

  """
  def change_purchased_ticket(%PurchasedTicket{} = purchased_ticket, attrs \\ %{}) do
    PurchasedTicket.changeset(purchased_ticket, attrs)
  end
end
