defmodule Rauversion.ConnectedAccountsTest do
  use Rauversion.DataCase

  alias Rauversion.ConnectedAccounts

  describe "connected_account" do
    alias Rauversion.ConnectedAccounts.ConnectedAccount

    import Rauversion.ConnectedAccountsFixtures

    @invalid_attrs %{state: nil}

    test "list/0 returns all connected_account" do
      connected_account = connected_account_fixture()
      assert ConnectedAccounts.list() == [connected_account]
    end

    test "get!/1 returns the connected_account with given id" do
      connected_account = connected_account_fixture()
      assert ConnectedAccounts.get!(connected_account.id) == connected_account
    end

    test "create/1 with valid data creates a connected_account" do
      valid_attrs = %{state: "some state"}

      assert {:ok, %ConnectedAccount{} = connected_account} =
               ConnectedAccounts.create(valid_attrs)

      assert connected_account.state == "some state"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ConnectedAccounts.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the connected_account" do
      connected_account = connected_account_fixture()
      update_attrs = %{state: "some updated state"}

      assert {:ok, %ConnectedAccount{} = connected_account} =
               ConnectedAccounts.update(connected_account, update_attrs)

      assert connected_account.state == "some updated state"
    end

    test "update/2 with invalid data returns error changeset" do
      connected_account = connected_account_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ConnectedAccounts.update(connected_account, @invalid_attrs)

      assert connected_account == ConnectedAccounts.get!(connected_account.id)
    end

    test "delete/1 deletes the connected_account" do
      connected_account = connected_account_fixture()

      assert {:ok, %ConnectedAccount{}} = ConnectedAccounts.delete(connected_account)

      assert_raise Ecto.NoResultsError, fn ->
        ConnectedAccounts.get!(connected_account.id)
      end
    end

    test "change/1 returns a connected_account changeset" do
      connected_account = connected_account_fixture()
      assert %Ecto.Changeset{} = ConnectedAccounts.change(connected_account)
    end
  end
end
