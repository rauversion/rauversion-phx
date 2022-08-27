defmodule Rauversion.PurchasedTicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.PurchasedTickets` context.
  """

  @doc """
  Generate a purchased_ticket.
  """
  def purchased_ticket_fixture(attrs \\ %{}) do
    {:ok, purchased_ticket} =
      attrs
      |> Enum.into(%{
        data: %{},
        state: "some state"
      })
      |> Rauversion.PurchasedTickets.create_purchased_ticket()

    purchased_ticket
  end
end
