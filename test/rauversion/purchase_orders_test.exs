defmodule Rauversion.PurchaseOrdersTest do
  use Rauversion.DataCase

  alias Rauversion.PurchaseOrders

  describe "purchase_orders" do
    alias Rauversion.PurchaseOrders.PurchaseOrder

    import Rauversion.PurchaseOrdersFixtures
    import Rauversion.AccountsFixtures

    @invalid_attrs %{promo_code: nil, total: nil, user_id: nil}

    setup do
      user = user_fixture()
      {:ok, %{user: user}}
    end

    test "list_purchase_orders/0 returns all purchase_orders", %{user: user} do
      purchase_order = purchase_order_fixture(%{user_id: user.id})
      assert PurchaseOrders.list_purchase_orders() == [purchase_order]
    end

    test "get_purchase_order!/1 returns the purchase_order with given id", %{user: user} do
      purchase_order = purchase_order_fixture(%{user_id: user.id})
      assert PurchaseOrders.get_purchase_order!(purchase_order.id) == purchase_order
    end

    test "create_purchase_order/1 with valid data creates a purchase_order", %{user: user} do
      valid_attrs = %{promo_code: "some promo_code", total: "120.5", user_id: user.id}

      assert {:ok, %PurchaseOrder{} = purchase_order} =
               PurchaseOrders.create_purchase_order(valid_attrs)

      assert purchase_order.promo_code == "some promo_code"
      assert purchase_order.total == Decimal.new("120.5")
    end

    test "create_purchase_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PurchaseOrders.create_purchase_order(@invalid_attrs)
    end

    test "update_purchase_order/2 with valid data updates the purchase_order", %{user: user} do
      purchase_order = purchase_order_fixture(%{user_id: user.id})
      update_attrs = %{promo_code: "some updated promo_code", total: "456.7"}

      assert {:ok, %PurchaseOrder{} = purchase_order} =
               PurchaseOrders.update_purchase_order(purchase_order, update_attrs)

      assert purchase_order.promo_code == "some updated promo_code"
      assert purchase_order.total == Decimal.new("456.7")
    end

    test "update_purchase_order/2 with invalid data returns error changeset", %{user: user} do
      purchase_order = purchase_order_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} =
               PurchaseOrders.update_purchase_order(purchase_order, @invalid_attrs)

      assert purchase_order == PurchaseOrders.get_purchase_order!(purchase_order.id)
    end

    test "delete_purchase_order/1 deletes the purchase_order", %{user: user} do
      purchase_order = purchase_order_fixture(%{user_id: user.id})
      assert {:ok, %PurchaseOrder{}} = PurchaseOrders.delete_purchase_order(purchase_order)

      assert_raise Ecto.NoResultsError, fn ->
        PurchaseOrders.get_purchase_order!(purchase_order.id)
      end
    end

    test "change_purchase_order/1 returns a purchase_order changeset", %{user: user} do
      purchase_order = purchase_order_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = PurchaseOrders.change_purchase_order(purchase_order)
    end
  end
end
