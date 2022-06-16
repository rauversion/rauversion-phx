defmodule Rauversion.Listings do
  @moduledoc """
  The Listings context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  @doc """
  Returns the list of listings.

  ## Examples

      iex> list_listings()
      [%Listing{}, ...]

  """
  def list_listings do
    []
  end

  @doc """
  Gets a single listing.

  Raises if the Listing does not exist.

  ## Examples

      iex> get_listing!(123)
      %Listing{}

  """
  def get_listing!(_id), do: nil

  @doc """
  Creates a listing.

  ## Examples

      iex> create_listing(%{field: value})
      {:ok, %Listing{}}

      iex> create_listing(%{field: bad_value})
      {:error, ...}

  """
  def create_listing(_attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a listing.

  ## Examples

      iex> update_listing(listing, %{field: new_value})
      {:ok, %Listing{}}

      iex> update_listing(listing, %{field: bad_value})
      {:error, ...}

  """

  # def update_listing(%Listing{} = listing, attrs) do
  #  raise "TODO"
  # end

  @doc """
  Deletes a Listing.

  ## Examples

      iex> delete_listing(listing)
      {:ok, %Listing{}}

      iex> delete_listing(listing)
      {:error, ...}

  """

  # def delete_listing(%Listing{} = listing) do
  #  raise "TODO"
  # end

  @doc """
  Returns a data structure for tracking listing changes.

  ## Examples

      iex> change_listing(listing)
      %Todo{...}

  """
  # def change_listing(%Listing{} = listing, _attrs \\ %{}) do
  #  raise "TODO"
  # end
end
