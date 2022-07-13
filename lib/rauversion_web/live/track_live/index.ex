defmodule RauversionWeb.TrackLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Tracks
  alias Rauversion.Tracks.Track
  alias Rauversion.Repo
  alias RauversionWeb.TrackLive.Step

  @impl true
  def mount(_params, _session, socket) do
    # @current_user
    socket =
      socket
      |> assign(:page, 1)
      |> assign(:tracks, [])

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

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket, socket.assigns.track.user_id) do
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
    |> assign(:tracks, list_tracks(socket.assigns.page))
    |> assign(:page_title, "Listing Tracks")
    |> assign(:track, nil)
  end

  defp list_tracks(page) do
    Tracks.list_public_tracks()
    |> Rauversion.Repo.paginate(page: page, page_size: 5)
  end
end
