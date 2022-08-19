defmodule RauversionWeb.ArticlesLive.Show do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, Posts, Repo}

  @impl true
  def mount(_params, _session, socket) do
    # @current_user
    {:ok,
     socket
     |> assign(:open, false)}
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

  defp apply_action(socket, :show, %{"id" => id}) do
    post = Posts.get_post_by_slug!(id) |> Repo.preload([:user])

    socket
    |> assign(:post, post)
    |> assign(:meta_tags, metatags(socket, post))
  end

  defp metatags(socket, post) do
    %{
      title: "#{post.title} on Rauversion",
      description: "Read #{post.title} by #{post.user.username} on Rauversion.",
      image:
        Application.get_env(:rauversion, :domain) <>
          Rauversion.Posts.variant_url(post, "cover", %{resize_to_limit: "360x360"})
    }
  end
end
