defmodule RauversionWeb.TrackLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Tracks
  alias Rauversion.Tracks.Track
  alias Rauversion.Repo
  alias RauversionWeb.TrackLive.Step

  # @impl true
  def mount(_params, session, socket) do
    # @current_user

    socket =
      socket
      |> assign(:tracks, list_tracks)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    case apply_action(socket, socket.assigns.live_action, params) do
      {:ok, reply} ->
        {:noreply, reply}

      {:err, err} ->
        {:noreply, err}

      any ->
        {:noreply, any}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket =
      socket
      |> assign(:step, %Step{name: "info", prev: "upload", next: "share"})
      |> assign(:page_title, "Edit Track")
      |> assign(
        :track,
        Tracks.get_track!(id) |> Repo.preload([:user, :cover_blob, :mp3_audio_blob])
      )

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket) do
      {:ok} ->
        socket

      err ->
        err
    end
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
    socket
    |> assign(:track, Tracks.get_track!(id))

    case authorize_user_resource(socket) do
      {:ok} ->
        {:ok, _} = Tracks.delete_track(socket.assigns.track)
        {:noreply, assign(socket, :tracks, list_tracks())}

      err ->
        err
    end
  end

  defp list_tracks do
    Tracks.list_tracks() |> Rauversion.Repo.preload([:user, :cover_blob, :mp3_audio_blob])
  end
end
