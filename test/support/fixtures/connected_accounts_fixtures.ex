defmodule Rauversion.ConnectedAccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.ConnectedAccounts` context.
  """

  @doc """
  Generate a connected_account.
  """
  def connected_account_fixture(attrs \\ %{}) do
    {:ok, connected_account} =
      attrs
      |> Enum.into(%{
        state: "some state"
      })
      |> Rauversion.ConnectedAccounts.create_connected_account()

    connected_account
  end
end
