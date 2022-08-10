defmodule RauversionWeb.PlaylistLive.AddToPlaylistComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:action, nil)
    }
  end

  def handle_event("add-to-playlist", %{"track" => _track_id}, socket) do
    # track = Rauversion.Tracks.get_track!(track_id) |> Rauversion.Repo.preload(:user)
    {
      :noreply,
      assign(socket, :action, "add")
      # |> assign(:track, track)
    }
  end

  def handle_event("close-modal", %{}, socket) do
    {
      :noreply,
      assign(socket, :action, nil)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800 sm:space-y-5">

      <%= if @action == "add" do %>
        <.modal close_handler={@myself}>
          <.live_component
            module={RauversionWeb.PlaylistLive.FormComponent}
            id={:new}
            title={"@page_title"}
            action={:new}
            track={@track}
            playlist={%Rauversion.Playlists.Playlist{}}
            current_user={@current_user}
          />
        </.modal>
      <% end %>


      <%= link to: "#",
        "phx-click": "add-to-playlist",
        "phx-target": @myself,
        "phx-value-track": @track.id,
        class: "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-700 shadow-sm text-xs font-medium rounded text-gray-700 bg-white dark:text-gray-300 dark:bg-black  hover:bg-gray-50 dark:hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
        <span>Add to playlist</span>
      <% end %>
    </div>

    """
  end
end
