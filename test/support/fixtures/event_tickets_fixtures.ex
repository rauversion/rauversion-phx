defmodule Rauversion.EventTicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.EventTickets` context.
  """

  @doc """
  Generate a event_ticket.
  """
  def event_ticket_fixture(attrs \\ %{}) do
    {:ok, event_ticket} =
      attrs
      |> Enum.into(%{
        early_bird_price: "120.5",
        price: "120.5",
        qty: 42,
        selling_end: ~U[2022-08-26 04:47:00Z],
        selling_start: ~U[2022-08-26 04:47:00Z],
        settings: %{},
        short_description: "some short_description",
        standard_price: "120.5",
        title: "some title"
      })
      |> Rauversion.EventTickets.create_event_ticket()

    event_ticket
  end
end
