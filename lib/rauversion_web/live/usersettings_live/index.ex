defmodule RauversionWeb.UserSettingsLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts}

  @impl true
  def mount(_params, session, socket) do
    socket =
      if session["user_token"] do
        user = Rauversion.Accounts.get_user_by_session_token(session["user_token"])

        socket
        |> get_change_set(user)
        |> assign(:current_user, user)
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("save", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    socket =
      case Accounts.apply_user_email(user, password, user_params) do
        {:ok, applied_user} ->
          Accounts.deliver_update_email_instructions(
            applied_user,
            user.email,
            &Routes.user_settings_url(socket, :confirm_email, &1)
          )

          socket
          |> put_flash(
            :info,
            "A link to confirm your email change has been sent to the new address."
          )
          |> push_redirect(to: socket.assigns.return_to)

        {:error, changeset} ->
          socket |> assign(:email_changeset, changeset)
      end

    {:noreply, socket}
  end

  defp get_change_set(socket, user) do
    get_change_set(socket.assigns.live_action, socket, user)
  end

  defp get_change_set(:contact, socket, user) do
    socket
    |> assign(:profile_changeset, Accounts.change_user_profile(user))
    |> assign(:return_to, "/users/settings")
  end

  defp get_change_set(:email, socket, user) do
    socket
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:return_to, "/users/settings/email")
  end

  defp get_change_set(:security, socket, user) do
    socket
    |> assign(:password_changeset, Accounts.change_user_password(user))
    |> assign(:return_to, "/users/settings/security")
  end

  defp get_change_set(_action, socket, _user) do
    socket
  end
end
