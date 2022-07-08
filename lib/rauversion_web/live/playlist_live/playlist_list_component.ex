defmodule RauversionWeb.PlaylistLive.PlaylistListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component
  alias Rauversion.{Playlists}

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(playlists: list_playlists(assigns))}
  end

  defp list_playlists(assigns) do
    Rauversion.Playlists.list_playlists_by_user(assigns.profile)
    |> Rauversion.Repo.all()
    |> Rauversion.Playlists.preload_playlists_preloaded_by_user(assigns[:current_user])
    |> Rauversion.Repo.preload(:user)
    |> Rauversion.Repo.preload(track_playlists: [track: [:cover_blob, :mp3_audio_blob]])
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    playlist = Playlists.get_playlist!(id)
    {:ok, _} = Playlists.delete_playlist(playlist)

    {:noreply, assign(socket, :playlists, list_playlists(socket.assigns))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= for playlist <- assigns.playlists  do %>
        <.live_component
          module={RauversionWeb.PlaylistLive.PlaylistComponent}
          id={"playlist-#{playlist.id}"}
          playlist={playlist}
          current_user={@current_user}
          list_ref={@myself}
        />
      <% end %>
    </div>
    """
  end
end
