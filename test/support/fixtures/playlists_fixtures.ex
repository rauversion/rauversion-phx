defmodule Rauversion.PlaylistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.Playlists` context.
  """

  @doc """
  Generate a playlist.
  """
  def playlist_fixture(attrs \\ %{}) do
    {:ok, result} =
      attrs
      |> Enum.into(%{
        description: "some description",
        metadata: %{},
        slug: "some slug",
        title: "some title"
      })
      |> Rauversion.Playlists.create_playlist()

    result.playlist_with_tracks
  end
end
