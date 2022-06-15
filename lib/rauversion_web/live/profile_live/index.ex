defmodule RauversionWeb.ProfileLive.Index do
  use RauversionWeb, :live_view
  alias Rauversion.{Accounts, Tracks}

  @impl true
  def mount(params = %{"username" => id}, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    profile = Accounts.get_user_by_username(id)

    socket =
      socket
      |> assign(:current_user, user)
      |> assign(:profile, profile)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => id}) do
    # profile = Accounts.get_user_by_username(id)

    tracks = Tracks.list_tracks(%{user_id: id})

    socket
    |> assign(:tracks, tracks)
    |> assign(:page_title, "Edit Playlist")
    |> assign(:title, "all")
    |> assign(:data, menu(socket, id))
  end

  defp apply_action(socket, :tracks_all, %{"username" => id}) do
    # profile = Accounts.get_user_by_username(id)
    tracks = Tracks.list_tracks(%{user_id: id})

    socket
    |> assign(:page_title, "Tracks all")
    |> assign(:tracks, tracks)
    |> assign(:title, "popular")
    |> assign(:data, menu(socket, id))
  end

  def handle_params(%{"sort_by" => sort_by}, url, socket) do
    require IEx
    IEx.pry()
    # post_id = socket.assigns.post.id
    # do something with sort_by
  end

  defp menu(socket, id) do
    [
      %{name: "All", url: Routes.profile_index_path(socket, :index, id)},
      %{
        name: "Popular tracks",
        url: Routes.profile_index_path(socket, :tracks_all, id)
      },
      %{
        name: "Tracks",
        url: Routes.profile_index_path(socket, :tracks_all, id)
      },
      %{name: "Albums", url: Routes.profile_index_path(socket, :albums, id)},
      %{name: "Playlists", url: Routes.profile_index_path(socket, :playlists, id)},
      %{name: "Reposts", url: Routes.profile_index_path(socket, :reposts, id)}
    ]
  end

  # defp apply_action(socket, :new, _params) do
  #  socket
  #  |> assign(:page_title, "New Playlist")
  #  |> assign(:profile, %Playlist{})
  # end

  # defp apply_action(socket, :index, _params) do
  #  socket
  #  |> assign(:page_title, "Listing Playlists")
  #  |> assign(:profile, nil)
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #  playlist = Playlists.get_playlist!(id)
  #  {:ok, _} = Playlists.delete_playlist(playlist)

  #  {:noreply, assign(socket, :profiles, list_playlists())}
  # end

  # defp list_playlists do
  #  Playlists.list_playlists()
  # end
end
