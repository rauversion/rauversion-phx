defmodule RauversionWeb.FollowsLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Tracks.Track
  alias Rauversion.{Repo, Tracks, Accounts, UserFollows}
  alias RauversionWeb.TrackLive.Step

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

  defp apply_action(socket, :followers, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)
    follows = UserFollows.followers_list_for(user)

    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:follow_kind, "followers")
    |> assign(:profile, user)
    |> assign(:collection, follows)
  end

  defp apply_action(socket, :followings, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)
    follows = UserFollows.followings_list_for(user)

    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:profile, user)
    |> assign(:follow_kind, "followings")
    |> assign(:collection, follows)
  end

  defp apply_action(socket, :likes, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)

    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:profile, user)
    |> assign(:follow_kind, "likes")
    |> assign(:collection, [])
  end

  defp apply_action(socket, :comments, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)

    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:profile, user)
    |> assign(:follow_kind, "comments")
    |> assign(:collection, [])
  end
end
