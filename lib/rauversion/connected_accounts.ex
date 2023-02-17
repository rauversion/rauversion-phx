defmodule Rauversion.ConnectedAccounts do
  @moduledoc """
  The ConnectedAccounts context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.ConnectedAccounts.ConnectedAccount

  @doc """
  Returns the list of connected_account.

  ## Examples

      iex> list_connected_account()
      [%ConnectedAccount{}, ...]

  """
  def list_connected_account do
    Repo.all(ConnectedAccount)
  end

  @doc """
  Gets a single connected_account.

  Raises `Ecto.NoResultsError` if the Connected account does not exist.

  ## Examples

      iex> get_connected_account!(123)
      %ConnectedAccount{}

      iex> get_connected_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_connected_account!(id), do: Repo.get!(ConnectedAccount, id)

  @doc """
  Creates a connected_account.

  ## Examples

      iex> create_connected_account(%{field: value})
      {:ok, %ConnectedAccount{}}

      iex> create_connected_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_connected_account(attrs \\ %{}) do
    %ConnectedAccount{}
    |> ConnectedAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a connected_account.

  ## Examples

      iex> update_connected_account(connected_account, %{field: new_value})
      {:ok, %ConnectedAccount{}}

      iex> update_connected_account(connected_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_connected_account(%ConnectedAccount{} = connected_account, attrs) do
    connected_account
    |> ConnectedAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a connected_account.

  ## Examples

      iex> delete_connected_account(connected_account)
      {:ok, %ConnectedAccount{}}

      iex> delete_connected_account(connected_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_connected_account(%ConnectedAccount{} = connected_account) do
    Repo.delete(connected_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking connected_account changes.

  ## Examples

      iex> change_connected_account(connected_account)
      %Ecto.Changeset{data: %ConnectedAccount{}}

  """
  def change_connected_account(%ConnectedAccount{} = connected_account, attrs \\ %{}) do
    ConnectedAccount.changeset(connected_account, attrs)
  end
end
