defmodule Rauversion.PlaylistLikesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.PlaylistLikes` context.
  """

  @doc """
  Generate a playlist_like.
  """
  def playlist_like_fixture(attrs \\ %{}) do
    {:ok, playlist_like} =
      attrs
      |> Enum.into(%{})
      |> Rauversion.PlaylistLikes.create_playlist_like()

    playlist_like
  end
end
