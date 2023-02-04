defmodule Rauversion.Merchandising do
  @moduledoc """
  The Merchandising context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Merchandising.Merch

  @doc """
  Returns the list of merchs.

  ## Examples

      iex> list_merchs()
      [%Merch{}, ...]

  """
  def list_merchs do
    Repo.all(Merch)
  end

  @doc """
  Gets a single merch.

  Raises `Ecto.NoResultsError` if the Merch does not exist.

  ## Examples

      iex> get_merch!(123)
      %Merch{}

      iex> get_merch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_merch!(id), do: Repo.get!(Merch, id)

  @doc """
  Creates a merch.

  ## Examples

      iex> create_merch(%{field: value})
      {:ok, %Merch{}}

      iex> create_merch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_merch(attrs \\ %{}) do
    %Merch{}
    |> Merch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a merch.

  ## Examples

      iex> update_merch(merch, %{field: new_value})
      {:ok, %Merch{}}

      iex> update_merch(merch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_merch(%Merch{} = merch, attrs) do
    merch
    |> Merch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a merch.

  ## Examples

      iex> delete_merch(merch)
      {:ok, %Merch{}}

      iex> delete_merch(merch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_merch(%Merch{} = merch) do
    Repo.delete(merch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking merch changes.

  ## Examples

      iex> change_merch(merch)
      %Ecto.Changeset{data: %Merch{}}

  """
  def change_merch(%Merch{} = merch, attrs \\ %{}) do
    Merch.changeset(merch, attrs)
  end
end
