defmodule Rauversion.UserFollowsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.UserFollows` context.
  """

  @doc """
  Generate a user_follow.
  """
  def user_follow_fixture(attrs \\ %{}) do
    {:ok, user_follow} =
      attrs
      |> Enum.into(%{})
      |> Rauversion.UserFollows.create_user_follow()

    user_follow
  end
end
