defmodule RauversionWeb.LabelAuthController do
  use RauversionWeb, :controller
  alias Rauversion.Accounts

  def add(conn, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)

    case RauversionWeb.UserAuth.fetch_current_user(conn, []) do
      %{assigns: %{current_user: current_user}} ->
        case Rauversion.Accounts.is_child_of?(current_user, user.id) do
          %Rauversion.ConnectedAccounts.ConnectedAccount{} = connected_account ->
            connected_account = connected_account |> Rauversion.Repo.preload(:user)

            conn
            |> RauversionWeb.UserAuth.log_in_user_conn(connected_account.user)
            |> put_session(:parent_user, current_user.id)
            |> redirect(to: "/#{user.username}")

          _a ->
            conn
            |> put_flash(:error, gettext("not allowed"))
            |> redirect(to: "/#{current_user.username}")
        end

      _ ->
        conn
        |> put_flash(:error, gettext("not allowed"))
        |> RauversionWeb.UserAuth.log_in_user(user)
    end
  end
end
