defmodule RauversionWeb.UsersettingsLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Accounts
  alias RauversionWeb.UserAuth

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> get_change_set(assigns.current_user)
      |> assign(:return_to, Routes.user_settings_index_path(socket, assigns.action, assigns))

    {:ok, socket}
  end

  defp get_change_set(socket, user) do
    get_change_set(socket.assigns.action, socket, user)
  end

  defp get_change_set(:profile, socket, user) do
    socket
    |> assign(:changeset, Accounts.change_user_profile(user))
    |> allow_upload(:avatar,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1,
      max_file_size: 15_000_000
    )
    |> allow_upload(:profile_header,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1,
      max_file_size: 15_000_000
    )
  end

  defp get_change_set(:email, socket, user) do
    socket
    |> assign(:changeset, Accounts.change_user_email(user))
  end

  defp get_change_set(:security, socket, user) do
    socket
    |> assign(:changeset, Accounts.change_user_password(user))
  end

  defp get_change_set(:notifications, socket, user) do
    socket
    |> assign(:changeset, Accounts.change_user_notifications(user))
  end

  defp get_change_set(:transbank, socket, user) do
    socket
    |> assign(:changeset, Accounts.change_user_notifications(user))
  end

  defp get_change_set(:integrations, socket, _user) do
    socket
  end

  defp get_change_set(:invitations, socket, _user) do
    socket
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "save",
        %{"action" => "update_email"} = params,
        socket = %{assigns: %{action: :email}}
      ) do
    save_email(socket, socket.assigns.action, params)
  end

  @impl true
  def handle_event(
        "save",
        %{"action" => "update_notifications"} = params,
        socket = %{assigns: %{action: :notifications}}
      ) do
    save_notifications(socket, socket.assigns.action, params)
  end

  @impl true
  def handle_event(
        "save",
        %{"action" => "update_transbank_settings"} = params,
        socket = %{assigns: %{action: :transbank}}
      ) do
    save_transbank(socket, socket.assigns.action, params)
  end

  @impl true
  def handle_event(
        "save",
        %{"action" => "update_password"} = params,
        socket = %{
          assigns: %{
            action: :security
          }
        }
      ) do
    save_password(socket, socket.assigns.action, params)
  end

  @impl true
  def handle_event(
        "save",
        %{"action" => "update_profile"} = params,
        socket = %{
          assigns: %{
            action: :profile
          }
        }
      ) do
    save_profile(socket, socket.assigns.action, params)
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
          socket |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  defp save_password(socket, :security, params) do
    %{"user" => user_params} = params
    %{"current_password" => password} = user_params
    user = socket.assigns.current_user

    socket =
      case Accounts.update_user_password(user, password, user_params) do
        {:ok, user} ->
          socket
          |> UserAuth.log_in_user(user)
          |> put_flash(:info, "Password updated successfully.")

        # |> PhoenixLiveSession.put_session(:user_return_to, "/user/settings/security")

        {:error, changeset} ->
          socket |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  defp save_profile(socket, :profile, %{"user" => user_params}) do
    user = socket.assigns.current_user

    user_params =
      user_params
      |> Map.put("avatar", files_for(socket, :avatar))
      |> Map.put("profile_header", files_for(socket, :profile_header))

    IO.inspect(user_params)

    socket =
      case Accounts.update_user_profile(user, user_params) do
        {:ok, _user} ->
          socket
          |> put_flash(:info, "User profile updated successfully.")
          |> push_redirect(to: "/users/settings")

        {:error, changeset} ->
          socket |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  defp save_profile(socket, :notifications, %{"user" => user_params}) do
    user = socket.assigns.current_user

    socket =
      case Accounts.update_user_profile(user, user_params) do
        {:ok, _user} ->
          socket
          |> put_flash(:info, "User profile updated successfully.")
          |> redirect(to: "/users/settings")

        {:error, changeset} ->
          socket |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  defp save_notifications(socket, :notifications, %{"user" => user_params}) do
    user = socket.assigns.current_user

    socket =
      case Accounts.update_notifications(user, user_params) do
        {:ok, _user} ->
          socket
          |> put_flash(:info, "User profile updated successfully.")
          |> redirect(to: "/users/settings/notifications")

        {:error, changeset} ->
          socket |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  defp save_transbank(socket, :transbank, %{"user" => user_params}) do
    user = socket.assigns.current_user

    socket =
      case Accounts.update_transbank(user, user_params) do
        {:ok, _user} ->
          socket
          |> put_flash(:info, "User profile updated successfully.")
          |> redirect(to: "/users/settings/transbank")

        {:error, changeset} ->
          socket |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end
end
