defmodule RauversionWeb.ProfileLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, Tracks, UserFollows, Repo}

  @impl true
  def mount(params = %{"username" => id}, session, socket) do
    socket =
      socket
      |> assign(:profile, Accounts.get_user_by_username(id))
      |> assign(:who_to_follow, who_to_follow())
      |> assign(:share_track, nil)

    Tracks.subscribe()

    {:ok, socket}
  end

  defp who_to_follow() do
    Rauversion.Accounts.unfollowed_users(@profile)
    |> Rauversion.Repo.paginate(page: 1, page_size: 5)
  end

  @impl true
  def handle_event("share-track-modal", %{"id" => id}, socket) do
    {:noreply,
     assign(
       socket,
       :share_track,
       Tracks.get_track!(id) |> Repo.preload(user: :avatar_attachment)
     )}
  end

  @impl true
  def handle_event("follow-account", %{"id" => id}, socket) do
    UserFollows.create_user_follow(%{
      follower_id: socket.assigns.current_user.id,
      following_id: id
    })

    {:noreply, socket}
  end

  # @impl true
  # def handle_info({Tracks, [:tracks, _], _}, socket) do
  #  IO.puts("OLIII")
  #  {:noreply, assign(socket, :tracks, Tracks.list_tracks())}
  # end

  @impl true
  def handle_info(
        {Tracks, [:tracks, :destroyed], %Tracks.Track{user_id: user_id} = deleted_track},
        socket
      ) do
    IO.puts("HANDLE DELETE TRACK EVENT")

    cond do
      user_id == socket.assigns.profile.id ->
        {:noreply,
         assign(
           socket,
           :tracks,
           socket.assigns.tracks |> Enum.filter(fn t -> t.id != deleted_track.id end)
         )}

      true ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => id}) do
    # profile = Accounts.get_user_by_username(id)
    tracks =
      Tracks.list_tracks_by_username(id)
      |> Repo.preload([
        :mp3_audio_blob,
        :cover_blob,
        :cover_attachment,
        user: :avatar_attachment
      ])

    socket
    |> assign(:tracks, tracks)
    |> assign(:page_title, "Edit Playlist")
    |> assign(:title, "all")
    |> assign(:data, menu(socket, id))
  end

  defp apply_action(socket, :tracks_all, %{"username" => id}) do
    # profile = Accounts.get_user_by_username(id)
    tracks =
      Tracks.list_tracks_by_username(id)
      |> Repo.preload([:cover_blob, :mp3_audio_blob])

    socket
    |> assign(:page_title, "Tracks all")
    |> assign(:tracks, tracks)
    |> assign(:title, "popular")
    |> assign(:data, menu(socket, id))
  end

  def handle_params(%{"sort_by" => _sort_by}, _url, _socket) do
    require IEx
    IEx.pry()
    # post_id = socket.assigns.post.id
    # do something with sort_by
  end

  @impl true
  def handle_event("delete-track", %{"id" => id}, socket) do
    track = Tracks.get_track!(id)

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket, track.user_id) do
      {:ok, socket} ->
        {:ok, _} = Tracks.delete_track(track)
        {:noreply, socket}

      _err ->
        {:noreply, socket}
    end
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
