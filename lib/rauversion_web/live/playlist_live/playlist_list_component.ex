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
     |> assign(page: 1)
     |> assign(playlists: list_playlists(assigns))}
  end

  defp list_playlists(assigns) do
    Rauversion.Playlists.list_playlists_by_user(
      assigns.profile,
      assigns[:current_user]
    )
    |> Rauversion.Repo.paginate(page: assigns.page, page_size: 5)

    # |> Rauversion.Repo.preload(:user)
    # |> Rauversion.Repo.preload(track_playlists: [track: [:cover_blob, :mp3_audio_blob]])
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    playlist = Playlists.get_playlist!(id)

    case Playlists.delete_playlist(playlist) do
      {:ok, playlist} ->
        {:noreply, push_event(socket, "remove-item", %{id: "playlist-item-#{playlist.id}"})}

      _ ->
        # not sire what to reply here
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("paginate", %{}, socket) do
    {:noreply,
     socket
     |> assign(:page, socket.assigns.page + 1)
     |> assign(:playlists, list_playlists(socket.assigns))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="infinite-scroll"
      phx-hook="InfiniteScroll"
      phx-update="append"
      data-page={@page}
      phx-target={@myself}
      data-paginate-end={assigns.playlists.total_pages == @page}
      >
      <%= for playlist <- assigns.playlists.entries  do %>
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
