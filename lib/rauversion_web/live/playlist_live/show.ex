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
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:playlist, get_playlist(id))}
  end

  defp get_playlist(id) do
    Playlists.get_playlist!(id)
    |> Rauversion.Repo.preload([:user, :cover_blob, [track_playlists: [track: :user]]])
  end

  defp page_title(:show), do: "Show Playlist"
  defp page_title(:edit), do: "Edit Playlist"
end
