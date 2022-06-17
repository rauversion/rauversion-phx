defmodule RauversionWeb.TrackLive.Index do
  use RauversionWeb, :live_view

  alias Rauversion.Tracks
  alias Rauversion.Tracks.Track
  alias Rauversion.Repo

  @impl true
  def mount(_params, session, socket) do
    @current_user

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

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Track")
    |> assign(:track, Tracks.get_track!(id) |> Repo.preload(:user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Track")
    |> assign(:track, %Track{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:track, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    track = Tracks.get_track!(id)
    {:ok, _} = Tracks.delete_track(track)

    {:noreply, assign(socket, :tracks, list_tracks())}
  end

  defp list_tracks do
    Tracks.list_tracks()
  end
end
