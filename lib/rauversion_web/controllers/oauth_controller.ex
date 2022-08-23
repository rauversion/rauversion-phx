defmodule RauversionWeb.OAuthController do
  use RauversionWeb, :controller
  alias Rauversion.UserFromAuth
  alias RauversionWeb.UserAuth
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    IO.inspect(fails)

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, user} <- UserFromAuth.find_or_create(auth),
         {:ok, %{user: user}} <- Rauversion.Accounts.get_or_create_user(user) do
      conn
      |> put_flash(:info, "Successfully authenticated.")
      # |> Auth.put_current_user(user)
      |> UserAuth.log_in_user(user)

      # |> redirect(to: "/")
    else
      {:error, %{user_data: user_data}} ->
        # this case is when email is blank, (twitter)
        conn
        |> put_session(:post_register_oauth_credential, user_data)
        |> redirect(to: "/users/register")

      {:error, _} ->
        conn
        |> put_flash(:error, "reason")
        |> redirect(to: "/")
    end
  end
end
