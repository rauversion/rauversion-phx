defmodule RauversionWeb.PlaylistLive.PlaylistShowItemsComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="my-2 p-2 border shadow-xs mx-3">
        <div class="flex space-x-3">
          <div class="flex-grow">
            <div class="flex flex-col">
              <div class="space-y-2">

                <ul role="list" class="-my-5 divide-y divide-gray-200">
                  <%= for track_playlists <- @playlist.track_playlists do %>
                    <li class="py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">

                            <a href="#"
                              phx-click="change-track"
                              phx-value-id={track_playlists.track.id}>
                              <%= track_playlists.track.title %>
                            </a>

                          </p>
                          <p class="text-sm text-gray-500 truncate">
                            <%= live_redirect track_playlists.track.user.username,
                              to: Routes.profile_index_path(@socket, :index, track_playlists.track.user.username)

                            %>
                          </p>
                        </div>
                      </div>
                    </li>
                  <% end %>
                </ul>
              </div>

            </div>
          </div>
        </div>
      </div>
    """
  end
end
