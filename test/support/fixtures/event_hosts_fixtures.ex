defmodule Rauversion.EventHostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.EventHosts` context.
  """

  @doc """
  Generate a event_host.
  """
  def event_host_fixture(attrs \\ %{}) do
    {:ok, event_host} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Rauversion.EventHosts.create_event_host()

    event_host
  end
end
