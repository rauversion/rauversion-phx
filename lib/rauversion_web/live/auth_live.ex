defmodule RauversionWeb.UserLiveAuth do
  # import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    socket = socket |> RauversionWeb.LiveHelpers.get_user_by_session(session)

    if socket.assigns |> Map.get(:current_user) do
      {:cont, socket}
    else
      {:cont, socket}
      # {:halt, redirect(socket, to: "/users/log_in")}
    end
  end
end
