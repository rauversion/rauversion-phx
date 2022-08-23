defmodule Rauversion.OauthCredentialsTest do
  use Rauversion.DataCase

  alias Rauversion.OauthCredentials

  describe "oauth_credentials" do
    alias Rauversion.OauthCredentials.OauthCredential

    import Rauversion.AccountsFixtures
    import Rauversion.OauthCredentialsFixtures

    @invalid_attrs %{data: nil, token: nil, uid: nil}

    test "list_oauth_credentials/0 returns all oauth_credentials" do
      user = user_fixture()

      oauth_credential = oauth_credential_fixture(%{user_id: user.id})

      assert OauthCredentials.list_oauth_credentials() == [oauth_credential]
    end

    test "get_oauth_credential!/1 returns the oauth_credential with given id" do
      user = user_fixture()
      oauth_credential = oauth_credential_fixture(%{user_id: user.id})
      assert OauthCredentials.get_oauth_credential!(oauth_credential.id) == oauth_credential
    end

    test "create_oauth_credential/1 with valid data creates a oauth_credential" do
      user = user_fixture()

      valid_attrs = %{
        data: %{token: "aaaa"},
        token: "some token",
        uid: "some uid",
        user_id: user.id,
        provider: "foo"
      }

      assert {:ok, %OauthCredential{} = oauth_credential} =
               OauthCredentials.create_oauth_credential(valid_attrs)

      assert %{token: "aaaa"} = oauth_credential.data
      assert oauth_credential.token == "some token"
      assert oauth_credential.uid == "some uid"
    end

    test "create_oauth_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               OauthCredentials.create_oauth_credential(@invalid_attrs)
    end

    test "update_oauth_credential/2 with valid data updates the oauth_credential" do
      user = user_fixture()
      oauth_credential = oauth_credential_fixture(%{user_id: user.id})

      update_attrs = %{
        data: %{token: "aaaa"},
        token: "some updated token",
        uid: "some updated uid"
      }

      assert {:ok, %OauthCredential{} = oauth_credential} =
               OauthCredentials.update_oauth_credential(oauth_credential, update_attrs)

      assert %{token: "aaaa"} = oauth_credential.data
      assert oauth_credential.token == "some updated token"
      assert oauth_credential.uid == "some updated uid"
    end

    test "update_oauth_credential/2 with invalid data returns error changeset" do
      user = user_fixture()
      oauth_credential = oauth_credential_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} =
               OauthCredentials.update_oauth_credential(oauth_credential, @invalid_attrs)

      assert oauth_credential == OauthCredentials.get_oauth_credential!(oauth_credential.id)
    end

    test "delete_oauth_credential/1 deletes the oauth_credential" do
      user = user_fixture()
      oauth_credential = oauth_credential_fixture(%{user_id: user.id})

      assert {:ok, %OauthCredential{}} =
               OauthCredentials.delete_oauth_credential(oauth_credential)

      assert_raise Ecto.NoResultsError, fn ->
        OauthCredentials.get_oauth_credential!(oauth_credential.id)
      end
    end

    test "change_oauth_credential/1 returns a oauth_credential changeset" do
      user = user_fixture()
      oauth_credential = oauth_credential_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = OauthCredentials.change_oauth_credential(oauth_credential)
    end
  end
end
