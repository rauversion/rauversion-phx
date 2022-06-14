defmodule Rauversion.TracksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.Tracks` context.
  """

  @doc """
  Generate a track.
  """
  def track_fixture(attrs \\ %{}) do
    {:ok, track} =
      attrs
      |> Enum.into(%{
        caption: "some caption",
        description: "some description",
        metadata: %{},
        notification_settings: %{},
        private: true,
        slug: "some slug",
        title: "some title"
      })
      |> Rauversion.Tracks.create_track()

    track
  end
end
