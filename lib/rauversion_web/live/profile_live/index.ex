defmodule RauversionWeb.ProfileLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, Tracks, UserFollows}

  @impl true
  def mount(_params = %{"username" => id}, _session, socket) do
    profile = Accounts.get_user_by_username(id)

    socket =
      socket
      |> assign(:profile, profile)
      |> assign(
        :user_follow,
        get_follow_for_current_user(profile.id, socket.assigns.current_user)
      )
      |> assign(:share_track, nil)

    Tracks.subscribe()

    {:ok, socket}
  end

  defp get_follow_for_current_user(id, _current_user = %Accounts.User{id: current_user_id}) do
    UserFollows.following_for(current_user_id, id)
  end

  defp get_follow_for_current_user(_id, _current_user = nil) do
    nil
  end

  # @impl true
  # def handle_info({Tracks, [:tracks, _], _}, socket) do
  #  IO.puts("OLIII")
  #  {:noreply, assign(socket, :tracks, Tracks.list_tracks())}
  # end

  @impl true
  def handle_event("follow-user", %{}, socket) do
    UserFollows.create_user_follow(%{
      follower_id: socket.assigns.current_user.id,
      following_id: socket.assigns.profile.id
    })

    {:noreply,
     socket
     |> assign(
       :user_follow,
       get_follow_for_current_user(socket.assigns.profile.id, socket.assigns.current_user)
     )}
  end

  @impl true
  def handle_event("unfollow-user", %{}, socket) do
    UserFollows.delete_user_follow(socket.assigns.user_follow)

    {:noreply,
     socket
     |> assign(
       :user_follow,
       get_follow_for_current_user(socket.assigns.profile.id, socket.assigns.current_user)
     )}
  end

  @impl true
  def handle_info(
        {Tracks, [:tracks, :destroyed], %Tracks.Track{user_id: user_id} = deleted_track},
        socket
      ) do
    IO.puts("HANDLE DELETE TRACK EVENT")

    cond do
      user_id == socket.assigns.profile.id ->
        {:noreply, socket}

      # {:noreply,
      # assign(
      #   socket,
      #   :tracks,
      #   socket.assigns.tracks |> Enum.filter(fn t -> t.id != deleted_track.id end)
      # )}

      true ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"username" => id}) do
    socket
    |> assign(:page_title, "All tracks")
    |> assign(:title, "all")
    |> assign(:data, menu(socket, id, "all"))
  end

  defp apply_action(socket, :tracks_all, %{"username" => id}) do
    socket
    |> assign(:page_title, "All tracks")
    |> assign(:title, "all")
    |> assign(:data, menu(socket, id, "all"))
  end

  defp apply_action(socket, :reposts, %{"username" => id}) do
    socket
    |> assign(:page_title, "Reposts")
    |> assign(:title, "reposts")
    |> assign(:data, menu(socket, id, "reposts"))
  end

  defp apply_action(socket, :albums, %{"username" => id}) do
    socket
    |> assign(:title, "albums")
    |> assign(:data, menu(socket, id, "albums"))
  end

  defp apply_action(socket, :playlists, %{"username" => id}) do
    socket
    |> assign(:page_title, "Tracks all")
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

  defp menu(socket, id, kind) do
    [
      %{
        name: "All",
        selected: kind == "all",
        url: Routes.profile_index_path(socket, :index, id),
        kind: kind
      },
      # %{
      #  name: "Popular tracks",
      #  url: Routes.profile_index_path(socket, :popular, id),
      #  selected: kind == "popular",
      #  kind: kind
      # },
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
end
