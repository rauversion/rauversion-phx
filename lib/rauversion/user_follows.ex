defmodule Rauversion.UserFollows do
  @moduledoc """
  The UserFollows context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.UserFollows.UserFollow

  @doc """
  Returns the list of user_follows.

  ## Examples

      iex> list_user_follows()
      [%UserFollow{}, ...]

  """
  def list_user_follows do
    Repo.all(UserFollow)
  end

  def followers_list_for(user) do
    UserFollow
    |> where(following_id: ^user.id)
    |> Repo.all()
    |> Repo.preload([:following, :follower])
  end

  def followers_for(user) do
    UserFollow
    |> where(following_id: ^user.id)
    |> Repo.aggregate(:count, :id)
  end

  def followings_list_for(user) do
    UserFollow
    |> where(follower_id: ^user.id)
    |> Repo.all()
    |> Repo.preload([:following, :follower])
  end

  def followings_for(user) do
    UserFollow
    |> where(follower_id: ^user.id)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single user_follow.

  Raises `Ecto.NoResultsError` if the User follow does not exist.

  ## Examples

      iex> get_user_follow!(123)
      %UserFollow{}

      iex> get_user_follow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_follow!(id), do: Repo.get!(UserFollow, id)

  @doc """
  Creates a user_follow.

  ## Examples

      iex> create_user_follow(%{field: value})
      {:ok, %UserFollow{}}

      iex> create_user_follow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_follow(attrs \\ %{}) do
    %UserFollow{}
    |> UserFollow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_follow.

  ## Examples

      iex> update_user_follow(user_follow, %{field: new_value})
      {:ok, %UserFollow{}}

      iex> update_user_follow(user_follow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_follow(%UserFollow{} = user_follow, attrs) do
    user_follow
    |> UserFollow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_follow.

  ## Examples

      iex> delete_user_follow(user_follow)
      {:ok, %UserFollow{}}

      iex> delete_user_follow(user_follow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_follow(%UserFollow{} = user_follow) do
    Repo.delete(user_follow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_follow changes.

  ## Examples

      iex> change_user_follow(user_follow)
      %Ecto.Changeset{data: %UserFollow{}}

  """
  def change_user_follow(%UserFollow{} = user_follow, attrs \\ %{}) do
    UserFollow.changeset(user_follow, attrs)
  end
end
