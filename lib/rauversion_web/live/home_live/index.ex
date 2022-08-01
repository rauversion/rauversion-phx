defmodule RauversionWeb.HomeLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, UserFollows}

  @impl true
  def mount(_params, _session, socket) do
    # @current_user

    {:ok, socket}
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

  defp list_tracks(page) do
    Rauversion.Tracks.list_public_tracks()
    |> Rauversion.Tracks.with_processed()
    |> Rauversion.Tracks.order_by_likes()
    |> Rauversion.Repo.paginate(page: page, page_size: 4)
  end

  defp list_playlists(page) do
    Rauversion.Playlists.list_public_playlists()
    |> Rauversion.Playlists.order_by_likes()
    |> Rauversion.Repo.paginate(page: page, page_size: 6)
  end

  defp apply_action(socket, :index, _) do
    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:tracks, list_tracks(1))
    |> assign(:playlists, list_playlists(1))
  end
end
