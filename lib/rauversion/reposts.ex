defmodule Rauversion.Reposts do
  @moduledoc """
  The Reposts context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Reposts.Repost

  @doc """
  Returns the list of reposts.

  ## Examples

      iex> list_reposts()
      [%Repost{}, ...]

  """
  def list_reposts do
    Repo.all(Repost)
  end

  @doc """
  Gets a single repost.

  Raises `Ecto.NoResultsError` if the Repost does not exist.

  ## Examples

      iex> get_repost!(123)
      %Repost{}

      iex> get_repost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repost!(id), do: Repo.get!(Repost, id)

  @doc """
  Creates a repost.

  ## Examples

      iex> create_repost(%{field: value})
      {:ok, %Repost{}}

      iex> create_repost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repost(attrs \\ %{}) do
    %Repost{}
    |> Repost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a repost.

  ## Examples

      iex> update_repost(repost, %{field: new_value})
      {:ok, %Repost{}}

      iex> update_repost(repost, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_repost(%Repost{} = repost, attrs) do
    repost
    |> Repost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a repost.

  ## Examples

      iex> delete_repost(repost)
      {:ok, %Repost{}}

      iex> delete_repost(repost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repost(%Repost{} = repost) do
    Repo.delete(repost)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repost changes.

  ## Examples

      iex> change_repost(repost)
      %Ecto.Changeset{data: %Repost{}}

  """
  def change_repost(%Repost{} = repost, attrs \\ %{}) do
    Repost.changeset(repost, attrs)
  end
end
