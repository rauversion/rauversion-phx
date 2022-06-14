defmodule Rauversion.TrackPlaylistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.TrackPlaylists` context.
  """

  @doc """
  Generate a track_playlist.
  """
  def track_playlist_fixture(attrs \\ %{}) do
    {:ok, track_playlist} =
      attrs
      |> Enum.into(%{

      })
      |> Rauversion.TrackPlaylists.create_track_playlist()

    track_playlist
  end
end
