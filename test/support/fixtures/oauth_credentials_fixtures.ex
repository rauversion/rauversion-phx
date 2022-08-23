defmodule Rauversion.OauthCredentialsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.OauthCredentials` context.
  """

  @doc """
  Generate a oauth_credential.
  """
  def oauth_credential_fixture(attrs \\ %{}) do
    {:ok, oauth_credential} =
      attrs
      |> Enum.into(%{
        data: %{},
        token: "some token",
        uid: "some uid"
      })
      |> Rauversion.OauthCredentials.create_oauth_credential()

    oauth_credential
  end
end
