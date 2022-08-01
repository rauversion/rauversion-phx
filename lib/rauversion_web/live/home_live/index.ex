defmodule RauversionWeb.HomeLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, UserFollows, Repo, Playlists, Tracks}

  @impl true
  def mount(_params, _session, socket) do
    # @current_user

    {:ok, socket}
  end

  defp list_tracks(page) do
    Tracks.list_public_tracks()
    |> Tracks.with_processed()
    |> Tracks.order_by_likes()
    |> Rauversion.Repo.paginate(page: page, page_size: 4)
  end

  defp list_playlists(page) do
    Playlists.list_public_playlists()
    |> Playlists.order_by_likes()
    |> Repo.paginate(page: page, page_size: 6)
  end

  defp list_users(page, current_user = nil) do
    nil
  end

  defp list_users(page, current_user = %Accounts.User{}) do
    Accounts.unfollowed_users(current_user)
    |> Repo.paginate(page: 1, page_size: 5)
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

  defp apply_action(socket, :index, _) do
    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:tracks, list_tracks(1))
    |> assign(:playlists, list_playlists(1))
    |> assign(:users, list_users(1, socket.assigns.current_user))
  end
end
