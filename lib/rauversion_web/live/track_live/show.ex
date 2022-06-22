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
  def handle_params(%{"id" => id} = params, _, socket = %{assigns: %{live_action: :show}}) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:track, Tracks.get_track!(id) |> Repo.preload(:user))}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket = %{assigns: %{live_action: :edit}}) do
    socket =
      socket
      |> assign(:step, %Step{name: "info", prev: "upload", next: "share"})
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:track, Tracks.get_track!(id) |> Repo.preload(:user))

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket) do
      {:ok, socket} ->
        {:noreply, socket}

      {:err, err} ->
        {:noreply, err}
    end
  end

  defp page_title(:show), do: "Show Track"
  defp page_title(:edit), do: "Edit Track"
end
