defmodule Rauversion.ConnectedAccounts do
  @moduledoc """
  The ConnectedAccounts context.
  """

  # import Ecto.Query, warn: false
  # alias Rauversion.Repo

  # alias Rauversion.ConnectedAccounts.ConnectedAccount

  use Rauversion.AutoContext, Rauversion.ConnectedAccounts.ConnectedAccount

  def attach_existing_account(from, username) do
    case Rauversion.Accounts.get_user_by_username(username) do
      %Rauversion.Accounts.User{} = user ->
        __MODULE__.create(%{inviter_id: from.id, user_id: user})

      _ ->
        IO.puts("non")
    end
  end

  def attach_new_account(from, user_params) do
    case Rauversion.Accounts.create_user(user_params) do
      user ->
        __MODULE__.create(%{inviter_id: from.id, user_id: user})

      nil ->
        nil
    end
  end

  @doc """
  Returns the list of connected_account.

  ## Examples

      iex> list_connected_account()
      [%ConnectedAccount{}, ...]

  """

  # def list_connected_account do
  #  Repo.all(ConnectedAccount)
  # end

  @doc """
  Gets a single connected_account.

  Raises `Ecto.NoResultsError` if the Connected account does not exist.

  ## Examples

      iex> get_connected_account!(123)
      %ConnectedAccount{}

      iex> get_connected_account!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_connected_account!(id), do: Repo.get!(ConnectedAccount, id)

  @doc """
  Creates a connected_account.

  ## Examples

      iex> create_connected_account(%{field: value})
      {:ok, %ConnectedAccount{}}

      iex> create_connected_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def create_connected_account(attrs \\ %{}) do
  #  %ConnectedAccount{}
  #  |> ConnectedAccount.changeset(attrs)
  #  |> Repo.insert()
  # end

  @doc """
  Updates a connected_account.

  ## Examples

      iex> update_connected_account(connected_account, %{field: new_value})
      {:ok, %ConnectedAccount{}}

      iex> update_connected_account(connected_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def update_connected_account(%ConnectedAccount{} = connected_account, attrs) do
  #  connected_account
  #  |> ConnectedAccount.changeset(attrs)
  #  |> Repo.update()
  # end

  @doc """
  Deletes a connected_account.

  ## Examples

      iex> delete_connected_account(connected_account)
      {:ok, %ConnectedAccount{}}

      iex> delete_connected_account(connected_account)
      {:error, %Ecto.Changeset{}}

  """

  # def delete_connected_account(%ConnectedAccount{} = connected_account) do
  #  Repo.delete(connected_account)
  # end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking connected_account changes.

  ## Examples

      iex> change_connected_account(connected_account)
      %Ecto.Changeset{data: %ConnectedAccount{}}

  """
  # def change_connected_account(%ConnectedAccount{} = connected_account, attrs \\ %{}) do
  #  ConnectedAccount.changeset(connected_account, attrs)
  # end
end
