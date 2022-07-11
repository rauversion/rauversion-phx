defmodule RauversionWeb.UsersettingsLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Accounts


  @impl true
  def update(assigns, socket) do
    {:ok, socket
            |> assign(assigns)
            |> get_change_set(assigns.current_user)}
  end

  defp get_change_set(socket, user) do
    get_change_set(socket.assigns.live_action, socket, user)
  end

  defp get_change_set(:profile, socket, user) do
    socket
    |> assign(:profile_changeset, Accounts.change_user_profile(user))
    |> allow_upload(:image, accept: ~w(.jpg .jpeg .png))
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

end
