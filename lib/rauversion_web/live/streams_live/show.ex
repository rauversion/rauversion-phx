defmodule RauversionWeb.StreamsLive.Show do
  use RauversionWeb, :live_view

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
    socket |> assign(:id, id)
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto w-3/4 py-2">
      <script src="https://unpkg.com/@mux/mux-player"></script>
      <mux-player
        stream-type="on-demand"
        playback-id={@id}
        metadata-video-title="Test VOD"
        metadata-viewer-user-id="user-id-007">
      </mux-player>
    </div>
    """
  end
end
