defmodule RauversionWeb.ArticlesLive.New do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, Posts}

  @impl true
  def mount(_params, _session, socket) do
    # @current_user

    {
      :ok,
      socket
      |> assign(:open, false)
      |> assign(
        :post,
        Posts.new_post(%{})
      )
      |> assign(:content, "")
    }
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

  @impl true
  def handle_event("toggle-panel", %{"value" => ""}, socket) do
    {:noreply, socket |> assign(:open, !socket.assigns.open)}
  end

  @impl true
  def handle_event(
        "update-content",
        %{"content" => content},
        socket = %{
          assigns: %{post: %Ecto.Changeset{}, current_user: %Accounts.User{} = current_user}
        }
      ) do
    with {:ok, post} <-
           Posts.create_post(%{
             user_id: current_user.id,
             body: content
           }) do
      {:noreply,
       socket
       |> assign(:content, content)
       |> assign(:post, post)
       |> assign(:content, post.body)
       |> push_patch(to: "/articles/edit/#{post.id}", replace: true)}
    else
      err ->
        IO.inspect(err)
        # nil -> {:error, ...} an example that we can match here too
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event(
        "update-content",
        %{"content" => content},
        socket = %{
          assigns: %{post: %Posts.Post{} = post, current_user: %Accounts.User{} = current_user}
        }
      ) do
    IO.inspect(socket.assigns.post)

    with {:ok, updated_post} <-
           Posts.update_post(post, %{
             user_id: current_user.id,
             body: content
           }) do
      {:noreply,
       socket
       # |> assign(:content, content)
       |> assign(:content, post.body)
       |> assign(:post, updated_post)}
    else
      err ->
        IO.inspect(err)
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :index, _) do
    socket
  end

  defp apply_action(socket, :new, _) do
    socket
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    post = Posts.get_post!(id)

    socket
    |> assign(:post, post)
    |> assign(:content, post.body)
  end

  defp apply_action(socket, :edit, %{"slug" => id}) do
    post = Posts.get_post_by_slug!(id)

    socket
    |> assign(:post, post)
    |> assign(:content, post.body)
  end
end
