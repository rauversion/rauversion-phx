defmodule Rauversion.RepostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.Reposts` context.
  """

  @doc """
  Generate a repost.
  """
  def repost_fixture(attrs \\ %{}) do
    {:ok, repost} =
      attrs
      |> Enum.into(%{

      })
      |> Rauversion.Reposts.create_repost()

    repost
  end
end
