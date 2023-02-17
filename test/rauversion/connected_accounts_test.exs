defmodule Rauversion.ConnectedAccountsTest do
  use Rauversion.DataCase

  alias Rauversion.ConnectedAccounts

  describe "connected_account" do
    alias Rauversion.ConnectedAccounts.ConnectedAccount

    import Rauversion.ConnectedAccountsFixtures

    @invalid_attrs %{state: nil}

    test "list_connected_account/0 returns all connected_account" do
      connected_account = connected_account_fixture()
      assert ConnectedAccounts.list_connected_account() == [connected_account]
    end

    test "get_connected_account!/1 returns the connected_account with given id" do
      connected_account = connected_account_fixture()
      assert ConnectedAccounts.get_connected_account!(connected_account.id) == connected_account
    end

    test "create_connected_account/1 with valid data creates a connected_account" do
      valid_attrs = %{state: "some state"}

      assert {:ok, %ConnectedAccount{} = connected_account} = ConnectedAccounts.create_connected_account(valid_attrs)
      assert connected_account.state == "some state"
    end

    test "create_connected_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ConnectedAccounts.create_connected_account(@invalid_attrs)
    end

    test "update_connected_account/2 with valid data updates the connected_account" do
      connected_account = connected_account_fixture()
      update_attrs = %{state: "some updated state"}

      assert {:ok, %ConnectedAccount{} = connected_account} = ConnectedAccounts.update_connected_account(connected_account, update_attrs)
      assert connected_account.state == "some updated state"
    end

    test "update_connected_account/2 with invalid data returns error changeset" do
      connected_account = connected_account_fixture()
      assert {:error, %Ecto.Changeset{}} = ConnectedAccounts.update_connected_account(connected_account, @invalid_attrs)
      assert connected_account == ConnectedAccounts.get_connected_account!(connected_account.id)
    end

    test "delete_connected_account/1 deletes the connected_account" do
      connected_account = connected_account_fixture()
      assert {:ok, %ConnectedAccount{}} = ConnectedAccounts.delete_connected_account(connected_account)
      assert_raise Ecto.NoResultsError, fn -> ConnectedAccounts.get_connected_account!(connected_account.id) end
    end

    test "change_connected_account/1 returns a connected_account changeset" do
      connected_account = connected_account_fixture()
      assert %Ecto.Changeset{} = ConnectedAccounts.change_connected_account(connected_account)
    end
  end
end
