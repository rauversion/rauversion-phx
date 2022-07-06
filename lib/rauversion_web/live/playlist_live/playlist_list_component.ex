defmodule RauversionWeb.PlaylistLive.PlaylistListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <%= for playlist <- assigns.playlists  do %>
        <.live_component
          module={RauversionWeb.PlaylistLive.PlaylistComponent}
          id={"playlist-#{playlist.id}"}
          playlist={playlist}
          current_user={@current_user}
        />
      <% end %>
    </div>
    """
  end
end
