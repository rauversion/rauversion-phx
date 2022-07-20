defmodule RauversionWeb.TrackLive.ShareTrackButtonComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:share_track, nil)}
  end

  @impl true
  def handle_event("share-track-modal", %{"id" => _id}, socket) do
    {:noreply,
     assign(
       socket,
       :share_track,
       socket.assigns.track |> Rauversion.Repo.preload(user: :avatar_attachment)
     )}
  end

  @impl true
  def handle_event("close-modal", %{}, socket) do
    {
      :noreply,
      assign(socket, :action, nil)
      |> assign(:share_track, nil)
    }
  end

  @impl true
  def render(
        %{
          track: track
        } = assigns
      ) do
    ~H"""

    <div>

      <%= if @share_track do %>
        <.modal close_handler={@myself}>
          <.live_component
            id={"share-track-modal-#{@share_track.id}"}
            module={RauversionWeb.TrackLive.ShareTrackComponent}
            track={@share_track}
          />
        </.modal>
      <% end %>

      <%= link to: "#",
        phx_click: "share-track-modal",
        phx_value_id: track.id,
        phx_target: @myself,
        class: "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
          <path d="M15 8a3 3 0 10-2.977-2.63l-4.94 2.47a3 3 0 100 4.319l4.94 2.47a3 3 0 10.895-1.789l-4.94-2.47a3.027 3.027 0 000-.74l4.94-2.47C13.456 7.68 14.19 8 15 8z" />
        </svg>
        <span>Share</span>
      <% end %>

    </div>
    """
  end
end
