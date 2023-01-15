defmodule RauversionWeb.PlaylistLive.Show do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Playlists

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:like, nil) |> assign(:buy_modal, false)}
  end

  def update(assigns, socket) do
    case assigns do
      %{current_user: _current_user = %Rauversion.Accounts.User{}} ->
        like =
          case assigns.playlist.likes do
            [like] -> like
            _ -> nil
          end

        {
          :ok,
          socket
          |> assign(assigns)
          |> assign(:like, like)
        }

      _ ->
        {:ok, socket |> assign(:like, nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _, socket) do
    playlist = get_playlist(id, socket.assigns.live_action)

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
  def handle_event("pricing-tab", %{}, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, "pricing-tab")}
  end

  @impl true
  def handle_event("tracks-tab", %{}, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, "tracks-tab")}
  end

  @impl true
  def handle_event("share-track-modal", %{"id" => _id}, socket) do
    {:noreply,
     assign(
       socket,
       :share_playlist,
       socket.assigns.playlist |> Rauversion.Repo.preload(user: :avatar_attachment)
     )}
  end

  def handle_event(
        "like-playlist",
        %{"id" => _id},
        socket = %{
          assigns: %{playlist: playlist, current_user: current_user = %Rauversion.Accounts.User{}}
        }
      ) do
    attrs = %{user_id: current_user.id, playlist_id: playlist.id}

    case socket.assigns.like do
      %Rauversion.PlaylistLikes.PlaylistLike{} = playlist_like ->
        Rauversion.PlaylistLikes.delete_playlist_like(playlist_like)

        {:noreply,
         assign(socket, :like, nil)
         |> assign(:playlist, %{socket.assigns.playlist | likes_count: playlist.likes_count - 1})}

      _ ->
        {:ok, %Rauversion.PlaylistLikes.PlaylistLike{} = playlist_like} =
          Rauversion.PlaylistLikes.create_playlist_like(attrs)

        {:noreply,
         assign(socket, :like, playlist_like)
         |> assign(:playlist, %{socket.assigns.playlist | likes_count: playlist.likes_count + 1})}
    end
  end

  defp get_playlist(id, :private) do
    Rauversion.Playlists.find_by_signed_id!(id)
    |> Rauversion.Repo.preload([:user, :cover_blob, [track_playlists: [track: :user]]])
  end

  defp get_playlist(id, :edit) do
    Playlists.get_playlist!(id)
    |> Rauversion.Repo.preload([:user, :cover_blob, [track_playlists: [track: :user]]])
  end

  defp get_playlist(id, :show) do
    Playlists.get_playlist!(id)
    |> Rauversion.Repo.preload([:user, :cover_blob, [track_playlists: [track: :user]]])
  end

  defp page_title(:show), do: "Show Playlist"
  defp page_title(:edit), do: "Edit Playlist"
  defp page_title(:private), do: "Playlist private view"

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
