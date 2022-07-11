defmodule RauversionWeb.UserSettingsLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Accounts
  alias RauversionWeb.UserAuth


  @impl true
  def mount(_params, session, socket) do
    socket =
      if session["user_token"] do
        user = Rauversion.Accounts.get_user_by_session_token(session["user_token"])
        socket
        |> assign(:current_user, user)
      else
        socket
      end
      IO.puts("MOUNT!! SOCKET = #{inspect(socket)}")

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"action" => "update_email"} = params, socket = %{
    assigns: %{
      live_action: :email
    }
  }) do

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

  def handle_event("change", %{"action" => "update_profile"} = params, socket = %{
    assigns: %{
      live_action: :profile
    }
  }) do
    IO.puts("CHANGE ON PROFILE, params = #{inspect(params)}")
    {:noreply, socket}
  end
  def handle_event("save", %{"action" => "update_profile"} = params, socket = %{
    assigns: %{
      live_action: :profile
    }
  }) do
    IO.puts("PARAMS == #{inspect(params)}")
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


end
