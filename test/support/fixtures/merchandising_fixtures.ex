defmodule Rauversion.MerchandisingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.Merchandising` context.
  """

  @doc """
  Generate a merch.
  """
  def merch_fixture(attrs \\ %{}) do
    {:ok, merch} =
      attrs
      |> Enum.into(%{
        description: "some description",
        options: %{},
        pricing: "120.5",
        private: true,
        qty: 42,
        shipping_data: %{},
        title: "some title"
      })
      |> Rauversion.Merchandising.create_merch()

    merch
  end
end
