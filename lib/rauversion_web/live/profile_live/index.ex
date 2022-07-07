defmodule RauversionWeb.ProfileLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, Tracks, UserFollows, Repo, Reposts, Playlists}

  @impl true
  def mount(_params = %{"username" => id}, session, socket) do
    socket =
      socket
      |> assign(:profile, Accounts.get_user_by_username(id))
      |> assign(:share_track, nil)

    Tracks.subscribe()

    {:ok, socket}
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
      |> Tracks.preload_tracks_preloaded_by_user(socket.assigns[:current_user])
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
    |> assign(:data, menu(socket, id, "all"))
  end

  defp apply_action(socket, :tracks_all, %{"username" => id}) do
    # profile = Accounts.get_user_by_username(id)
    tracks =
      Tracks.list_tracks_by_username(id)
      |> Tracks.preload_tracks_preloaded_by_user(socket.assigns[:current_user])
      |> Repo.preload([:cover_blob, :mp3_audio_blob])

    socket
    |> assign(:page_title, "Tracks all")
    |> assign(:tracks, tracks)
    |> assign(:title, "tracks_all")
    |> assign(:data, menu(socket, id, "tracks_all"))
  end

  defp apply_action(socket, :reposts, %{"username" => id}) do
    profile = Accounts.get_user_by_username(id)

    reposts =
      Reposts.get_reposts_by_user_id(profile.id, socket.assigns[:current_user])
      # |> Rauversion.Repo.all()
      # |> Repo.preload(track: [:user, :cover_blob, :mp3_audio_blob])
      # |> Tracks.preload_tracks_preloaded_by_user(socket.assigns[:current_user].id)
      |> Rauversion.Repo.paginate(page: 1, page_size: 5)

    tracks =
      reposts.entries
      |> Enum.map(fn item -> item.track end)

    socket
    |> assign(:page_title, "Reposts")
    |> assign(:tracks, tracks)
    |> assign(:title, "reposts")
    |> assign(:data, menu(socket, id, "reposts"))
  end

  defp apply_action(socket, :albums, %{"username" => id}) do
    # profile = Accounts.get_user_by_username(id)
    socket
    |> assign(:title, "albums")
    |> assign(:data, menu(socket, id, "albums"))
  end

  defp apply_action(socket, :playlists, %{"username" => id}) do
    # profile = Accounts.get_user_by_username(id)
    # Playlists.list_playlists_by_user(socket.assigns.profile)
    # |> Repo.all()
    # |> Repo.preload(:user)
    # |> Repo.preload(track_playlists: [track: [:cover_blob, :mp3_audio_blob]])
    playlists =
      Rauversion.Playlists.list_playlists_by_user(socket.assigns.profile)
      |> Rauversion.Repo.all()
      |> Rauversion.Repo.preload(:user)
      |> Rauversion.Repo.preload(track_playlists: [track: [:cover_blob, :mp3_audio_blob]])

    # |> Repo.preload(tracks: [:cover_blob, :mp3_audio_blob])

    socket
    |> assign(:page_title, "Tracks all")
    |> assign(:playlists, playlists)
    |> assign(:title, "playlists")
    |> assign(:data, menu(socket, id, "playlists"))
  end

  defp apply_action(socket, :popular, %{"username" => id}) do
    socket
    |> assign(:title, "popular")
    |> assign(:data, menu(socket, id, "popular"))
  end

  defp apply_action(socket, :insights, %{"username" => id}) do
    socket
    |> assign(:title, "insights")
    |> assign(:data, menu(socket, id, "insights"))
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

  defp menu(socket, id, kind) do
    # IO.inspect("AAAAAAAAAA #{socket.assigns}")
    [
      %{
        name: "All",
        selected: kind == "all",
        url: Routes.profile_index_path(socket, :index, id),
        kind: kind
      },
      %{
        name: "Popular tracks",
        url: Routes.profile_index_path(socket, :popular, id),
        selected: kind == "popular",
        kind: kind
      },
      %{
        name: "Tracks",
        url: Routes.profile_index_path(socket, :tracks_all, id),
        selected: kind == "tracks_all",
        kind: kind
      },
      %{
        name: "Albums",
        url: Routes.profile_index_path(socket, :albums, id),
        selected: kind == "albums",
        kind: kind
      },
      %{
        name: "Playlists",
        url: Routes.profile_index_path(socket, :playlists, id),
        selected: kind == "playlists",
        kind: kind
      },
      %{
        name: "Reposts",
        url: Routes.profile_index_path(socket, :reposts, id),
        selected: kind == "reposts",
        kind: kind
      }
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
