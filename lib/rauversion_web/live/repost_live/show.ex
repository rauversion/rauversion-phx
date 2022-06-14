defmodule RauversionWeb.RepostLive.Show do
  use RauversionWeb, :live_view

  alias Rauversion.Reposts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:repost, Reposts.get_repost!(id))}
  end

  defp page_title(:show), do: "Show Repost"
  defp page_title(:edit), do: "Edit Repost"
end
