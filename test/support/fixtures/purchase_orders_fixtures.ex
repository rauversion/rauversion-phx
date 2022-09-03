defmodule Rauversion.PurchaseOrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.PurchaseOrders` context.
  """

  @doc """
  Generate a purchase_order.
  """
  def purchase_order_fixture(attrs \\ %{}) do
    {:ok, purchase_order} =
      attrs
      |> Enum.into(%{
        promo_code: "some promo_code",
        total: "120.5"
      })
      |> Rauversion.PurchaseOrders.create_purchase_order()

    purchase_order
  end
end
