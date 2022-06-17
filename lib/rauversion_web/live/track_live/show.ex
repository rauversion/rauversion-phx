defmodule RauversionWeb.TrackLive.Show do
  use RauversionWeb, :live_view

  alias Rauversion.{Tracks, Repo}

  @impl true
  def mount(_params, session, socket) do
    user = Rauversion.Accounts.get_user_by_session_token(session["user_token"])

    socket =
      socket
      |> assign(:current_user, user)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:track, Tracks.get_track!(id) |> Repo.preload(:user))}
  end

  defp page_title(:show), do: "Show Track"
  defp page_title(:edit), do: "Edit Track"
end
