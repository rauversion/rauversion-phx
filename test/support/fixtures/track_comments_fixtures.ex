defmodule Rauversion.TrackCommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.TrackComments` context.
  """

  @doc """
  Generate a track_comment.
  """
  def track_comment_fixture(attrs \\ %{}) do
    {:ok, track_comment} =
      attrs
      |> Enum.into(%{
        body: "some body",
        state: "some state",
        track_minute: 42
      })
      |> Rauversion.TrackComments.create_track_comment()

    track_comment
  end
end
