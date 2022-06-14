defmodule RauversionWeb.RepostLive.Index do
  use RauversionWeb, :live_view

  alias Rauversion.Reposts
  alias Rauversion.Reposts.Repost

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :reposts, list_reposts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Repost")
    |> assign(:repost, Reposts.get_repost!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Repost")
    |> assign(:repost, %Repost{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reposts")
    |> assign(:repost, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    repost = Reposts.get_repost!(id)
    {:ok, _} = Reposts.delete_repost(repost)

    {:noreply, assign(socket, :reposts, list_reposts())}
  end

  defp list_reposts do
    Reposts.list_reposts()
  end
end
