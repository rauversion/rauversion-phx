defmodule Rauversion.PurchaseOrdersTest do
  use Rauversion.DataCase

  alias Rauversion.PurchaseOrders

  describe "purchase_orders" do
    alias Rauversion.PurchaseOrders.PurchaseOrder

    import Rauversion.PurchaseOrdersFixtures

    @invalid_attrs %{promo_code: nil, total: nil}

    test "list_purchase_orders/0 returns all purchase_orders" do
      purchase_order = purchase_order_fixture()
      assert PurchaseOrders.list_purchase_orders() == [purchase_order]
    end

    test "get_purchase_order!/1 returns the purchase_order with given id" do
      purchase_order = purchase_order_fixture()
      assert PurchaseOrders.get_purchase_order!(purchase_order.id) == purchase_order
    end

    test "create_purchase_order/1 with valid data creates a purchase_order" do
      valid_attrs = %{promo_code: "some promo_code", total: "120.5"}

      assert {:ok, %PurchaseOrder{} = purchase_order} = PurchaseOrders.create_purchase_order(valid_attrs)
      assert purchase_order.promo_code == "some promo_code"
      assert purchase_order.total == Decimal.new("120.5")
    end

    test "create_purchase_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PurchaseOrders.create_purchase_order(@invalid_attrs)
    end

    test "update_purchase_order/2 with valid data updates the purchase_order" do
      purchase_order = purchase_order_fixture()
      update_attrs = %{promo_code: "some updated promo_code", total: "456.7"}

      assert {:ok, %PurchaseOrder{} = purchase_order} = PurchaseOrders.update_purchase_order(purchase_order, update_attrs)
      assert purchase_order.promo_code == "some updated promo_code"
      assert purchase_order.total == Decimal.new("456.7")
    end

    test "update_purchase_order/2 with invalid data returns error changeset" do
      purchase_order = purchase_order_fixture()
      assert {:error, %Ecto.Changeset{}} = PurchaseOrders.update_purchase_order(purchase_order, @invalid_attrs)
      assert purchase_order == PurchaseOrders.get_purchase_order!(purchase_order.id)
    end

    test "delete_purchase_order/1 deletes the purchase_order" do
      purchase_order = purchase_order_fixture()
      assert {:ok, %PurchaseOrder{}} = PurchaseOrders.delete_purchase_order(purchase_order)
      assert_raise Ecto.NoResultsError, fn -> PurchaseOrders.get_purchase_order!(purchase_order.id) end
    end

    test "change_purchase_order/1 returns a purchase_order changeset" do
      purchase_order = purchase_order_fixture()
      assert %Ecto.Changeset{} = PurchaseOrders.change_purchase_order(purchase_order)
    end
  end
end
