defmodule RauversionWeb.UsersettingsLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Accounts


  @impl true
  def update(assigns, socket) do
    socket = socket
            |> assign(assigns)
            |> get_change_set(assigns.current_user)
    {:ok, socket}
  end


  defp get_change_set(socket, user) do
    get_change_set(socket.assigns.action, socket, user)
  end

  defp get_change_set(:profile, socket, user) do
    socket
    |> assign(:profile_changeset, Accounts.change_user_profile(user))
    |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1, max_file_size: 100_000_000, auto_upload: true)
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

  @impl true
  def handle_event("save", %{"action" => "update_email"} = params,
        socket = %{assigns: %{ action: :email } })
  do
    save_email(socket, socket.assigns.action, params)
  end

  @impl true
  def handle_event("save", %{"action" => "update_password"} = params, socket = %{
    assigns: %{
      live_action: :security
    }
  }) do
      %{"user" => user_params} = params
      %{"current_password" => password} = user_params
      user = socket.assigns.current_user
      socket =
        case Accounts.update_user_password(user, password, user_params) do
          {:ok, user} ->
            socket
              |> UserAuth.log_in_user(user)
              |> put_flash(:info, "Password updated successfully.")
              #|> PhoenixLiveSession.put_session(:user_return_to, "/user/settings/security")

          {:error, changeset} ->
            socket |> assign(:password_changeset, changeset)
        end
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"action" => "update_profile"} = params, socket = %{
    assigns: %{
      action: :profile
    }
  }) do
    IO.puts("SAVE UPDATE PROFILE")
    IO.puts("PARAMS == #{inspect(params)}")
    IO.puts("SOCKET == #{inspect(socket)}")

    IO.puts("ASIGNS == #{inspect(socket.assigns)}")

      %{"user" => user_params} = params
      IO.puts("USER_PARAMS == #{inspect(user_params)}")
      user = socket.assigns.current_user
      IO.puts("USER == #{inspect(user)}")
      socket = case Accounts.update_user_profile(user, user_params) do
        {:ok, _user} ->
          socket
          |> put_flash(:info, "User profile updated successfully.")
          |> redirect(to: "/users/settings")

        {:error, changeset} ->
          socket |> assign(:profile_changeset, changeset)
      end
      {:noreply, socket}
  end

  defp save_email(socket, :email, %{"current_password" => password, "user" => user_params}) do
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

end
