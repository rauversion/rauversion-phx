defmodule RauversionWeb.UserInvitationController do
  use RauversionWeb, :controller

  alias Rauversion.Accounts
  alias Rauversion.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_invitation(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.invite_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_invitation_instructions(
            user,
            &Routes.user_invitation_url(conn, :accept, &1)
          )

        conn
        |> put_flash(:info, "User invited successfully.")
        |> redirect(to: "/users")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def accept(conn, %{"token" => token}) do
    case Accounts.fetch_user_from_invitation(token) do
      {:ok, user} ->
        changeset = Accounts.change_user_invitation(user)
        render(conn, "accept.html", changeset: changeset, user: user, token: token)

      :error ->
        invalid_token(conn)
    end
  end

  def update_user(conn, %{"user" => user_params, "token" => token}) do
    case Accounts.accept_invitation(token, user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "User registered successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        case Accounts.fetch_user_from_invitation(token) do
          {:ok, user} ->
            render(conn, "accept.html", changeset: changeset, user: user, token: token)

          :error ->
            invalid_token(conn)
        end

      :error ->
        invalid_token(conn)
    end
  end

  defp invalid_token(conn) do
    conn
    |> put_flash(:error, "Invitation link is invalid or it has expired.")
    |> redirect(to: "/")
  end
end
