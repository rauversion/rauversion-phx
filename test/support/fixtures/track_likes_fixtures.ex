defmodule Rauversion.TrackLikesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.TrackLikes` context.
  """

  @doc """
  Generate a track_like.
  """
  def track_like_fixture(attrs \\ %{}) do
    {:ok, track_like} =
      attrs
      |> Enum.into(%{

      })
      |> Rauversion.TrackLikes.create_track_like()

    track_like
  end
end
