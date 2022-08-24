defmodule RauversionWeb.OAuthController do
  use RauversionWeb, :controller
  alias Rauversion.UserFromAuth
  alias RauversionWeb.UserAuth
  alias Rauversion.{Accounts, Repo}
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    IO.inspect(fails)

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, user} <- UserFromAuth.find_or_create(auth),
         {:ok, %{user: user}} <- Accounts.get_or_create_user(user) do
      conn
      |> put_flash(:info, "Successfully authenticated.")
      |> UserAuth.log_in_user(user)
    else
      # this case is when email is blank, (twitter)

      {:error, %{user_data: user_data}} ->
        # check if logged or not
        case conn.assigns.current_user do
          # logged sends to integrations and attach the credential
          %Accounts.User{} = user ->
            Accounts.create_oauth_credential(user, user_data)
            |> Repo.insert()

            conn |> redirect(to: "/users/settings/integrations")

          _ ->
            conn
            |> put_session(:post_register_oauth_credential, user_data)
            |> redirect(to: "/users/register")
        end

      {:error, _} ->
        conn
        |> put_flash(:error, "reason")
        |> redirect(to: "/")
    end
  end
end
