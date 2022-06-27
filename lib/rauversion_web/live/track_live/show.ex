defmodule RauversionWeb.TrackLive.Show do
  use RauversionWeb, :live_view

  alias Rauversion.{Tracks, Repo}
  alias RauversionWeb.TrackLive.Step

  @impl true
  def mount(_params, session, socket) do
    socket = RauversionWeb.LiveHelpers.get_user_by_session(socket, session)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _, socket = %{assigns: %{live_action: :show}}) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:track, Tracks.get_track!(id) |> Repo.preload(:user))}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _, socket = %{assigns: %{live_action: :edit}}) do
    socket =
      socket
      |> assign(:step, %Step{name: "info", prev: "upload", next: "share"})
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:current_tab, "basic-info-tab")
      |> assign(:track, Tracks.get_track!(id) |> Repo.preload(:user))

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket, socket.assigns.track.user_id) do
      {:ok, socket} ->
        {:noreply, socket}

      {:err, err} ->
        {:noreply, err}
    end
  end

  @impl true
  def handle_event("metadata-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("basic-info-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("permissions-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("share-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  defp page_title(:show), do: "Show Track"
  defp page_title(:edit), do: "Edit Track"
end
