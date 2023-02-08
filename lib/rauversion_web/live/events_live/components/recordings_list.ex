defmodule RauversionWeb.EventsLive.Components.RecordingsList do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <ul
      role="list"
      class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 lg:grid-cols-3 xl:gap-x-8"
    >
      <%= for item <- @event_recordings do %>
        <li class="relative">
          <iframe
            src={item.iframe}
            phx-update="ignore"
            id={"recording-frame-#{item.id}"}
            frameborder="0"
            allowfullscreen="true"
            scrolling="no"
            height="320"
            width="100%"
          >
          </iframe>
        </li>
      <% end %>
    </ul>
    """
  end
end
