defmodule Rauversion.ListingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.Listings` context.
  """

  @doc """
  Generate a listing.
  """
  def listing_fixture(attrs \\ %{}) do
    {:ok, listing} =
      attrs
      |> Enum.into(%{

      })
      |> Rauversion.Listings.create_listing()

    listing
  end
end
