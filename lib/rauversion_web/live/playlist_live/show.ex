defmodule RauversionWeb.PlaylistLive.Show do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Playlists

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    playlist = get_playlist(id)

    track =
      case playlist.track_playlists do
        [tp | _] -> tp.track
        _ -> nil
      end

    {:noreply,
     socket
     |> assign(:current_tab, "basic-info-tab")
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:playlist, playlist)
     |> assign(:track, track)
     |> assign(:meta_tags, metatags(playlist))}
  end

  @impl true
  def handle_event("change-track", %{"id" => id}, socket) do
    track =
      Rauversion.Tracks.get_track!(id)
      |> Rauversion.Repo.preload([:user, :mp3_audio_blob, :cover_blob])

    {:noreply,
     socket
     |> assign(:track, track)
     |> push_event("add-from-playlist", %{track_id: track.id})}

    # {
    #   :noreply,
    #   push_event(
    #     socket,
    #     "change-playlist-track",
    #     %{
    #       track_id: track.id,
    #       audio_peaks: Jason.encode!(Rauversion.Tracks.metadata(track, :peaks)),
    #       audio_url: Rauversion.Tracks.blob_proxy_url(track, "mp3_audio")
    #     }
    #   )
    # }
  end

  @impl true
  def handle_event("basic-info-tab", %{}, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, "basic-info-tab")}
  end

  @impl true
  def handle_event("metadata-tab", %{}, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, "metadata-tab")}
  end

  @impl true
  def handle_event("tracks-tab", %{}, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, "tracks-tab")}
  end

  defp get_playlist(id) do
    Playlists.get_playlist!(id)
    |> Rauversion.Repo.preload([:user, :cover_blob, [track_playlists: [track: :user]]])
  end

  defp page_title(:show), do: "Show Playlist"
  defp page_title(:edit), do: "Edit Playlist"

  defp metatags(playlist) do
    %{
      title: "#{playlist.title} on Rauversion",
      description:
        "Listen to #{playlist.title}, a playlist curated by #{playlist.user.username} on Rauversion."
      # url: "https://phoenix.meta.tags",
      # image: "https://phoenix.meta.tags/logo.png"
    }
  end
end
