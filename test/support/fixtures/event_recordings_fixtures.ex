defmodule Rauversion.EventRecordingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.EventRecordings` context.
  """

  @doc """
  Generate a event_recording.
  """
  def event_recording_fixture(attrs \\ %{}) do
    {:ok, event_recording} =
      attrs
      |> Enum.into(%{
        title: "some name",
        description: "bla blab",
        iframe: "http://aaa.com/aaa",
        properties: %{},
        type: "some type"
      })
      |> Rauversion.EventRecordings.create_event_recording()

    event_recording
  end
end
