defmodule Rauversion.MerchandisingTest do
  use Rauversion.DataCase

  alias Rauversion.Merchandising

  describe "merchs" do
    alias Rauversion.Merchandising.Merch

    import Rauversion.MerchandisingFixtures

    @invalid_attrs %{description: nil, options: nil, pricing: nil, private: nil, qty: nil, shipping_data: nil, title: nil}

    test "list_merchs/0 returns all merchs" do
      merch = merch_fixture()
      assert Merchandising.list_merchs() == [merch]
    end

    test "get_merch!/1 returns the merch with given id" do
      merch = merch_fixture()
      assert Merchandising.get_merch!(merch.id) == merch
    end

    test "create_merch/1 with valid data creates a merch" do
      valid_attrs = %{description: "some description", options: %{}, pricing: "120.5", private: true, qty: 42, shipping_data: %{}, title: "some title"}

      assert {:ok, %Merch{} = merch} = Merchandising.create_merch(valid_attrs)
      assert merch.description == "some description"
      assert merch.options == %{}
      assert merch.pricing == Decimal.new("120.5")
      assert merch.private == true
      assert merch.qty == 42
      assert merch.shipping_data == %{}
      assert merch.title == "some title"
    end

    test "create_merch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Merchandising.create_merch(@invalid_attrs)
    end

    test "update_merch/2 with valid data updates the merch" do
      merch = merch_fixture()
      update_attrs = %{description: "some updated description", options: %{}, pricing: "456.7", private: false, qty: 43, shipping_data: %{}, title: "some updated title"}

      assert {:ok, %Merch{} = merch} = Merchandising.update_merch(merch, update_attrs)
      assert merch.description == "some updated description"
      assert merch.options == %{}
      assert merch.pricing == Decimal.new("456.7")
      assert merch.private == false
      assert merch.qty == 43
      assert merch.shipping_data == %{}
      assert merch.title == "some updated title"
    end

    test "update_merch/2 with invalid data returns error changeset" do
      merch = merch_fixture()
      assert {:error, %Ecto.Changeset{}} = Merchandising.update_merch(merch, @invalid_attrs)
      assert merch == Merchandising.get_merch!(merch.id)
    end

    test "delete_merch/1 deletes the merch" do
      merch = merch_fixture()
      assert {:ok, %Merch{}} = Merchandising.delete_merch(merch)
      assert_raise Ecto.NoResultsError, fn -> Merchandising.get_merch!(merch.id) end
    end

    test "change_merch/1 returns a merch changeset" do
      merch = merch_fixture()
      assert %Ecto.Changeset{} = Merchandising.change_merch(merch)
    end
  end
end
