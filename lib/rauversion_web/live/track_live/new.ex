defmodule RauversionWeb.TrackLive.New do
  use RauversionWeb, :live_view

  alias Rauversion.Tracks
  alias Rauversion.Tracks.Track

  @impl true
  def mount(_params, session, socket) do
    user = Rauversion.Accounts.get_user_by_session_token(session["user_token"])

    socket =
      socket
      |> assign(:current_user, user)
      |> assign(:tracks, list_tracks)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Track")
    |> assign(:track, %Track{})
  end

  defp list_tracks do
    Tracks.list_tracks()
  end
end
