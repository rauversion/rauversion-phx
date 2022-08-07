defmodule Rauversion.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: %{},
        excerpt: "some excerpt",
        slug: "some slug",
        state: "some state",
        title: "some title"
      })
      |> Rauversion.Posts.create_post()

    post
  end
end
