defmodule RauversionWeb.PlaylistLive.PlaylistShowItemsComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="my-2 border dark:border-gray-800 shadow-xs mx-3 dark:bg-gray-900 rounded-md">
      <div class="flex space-x-3">
        <div class="flex-grow">
          <div class="flex flex-col">
            <div class="space-y-2">
              <ul role="list" class="divide-y divide-gray-200 dark:divide-gray-900">
                <%= for track_playlists <- @playlist.track_playlists do %>
                  <li>
                    <button
                      phx-click="change-track"
                      phx-value-id={track_playlists.track.id}
                      class="p-4 dark:bg-gray-800 dark:hover:bg-black hover:bg-200 w-full text-left">
                      <div class="flex items-center space-x-4">
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="none"
                          viewBox="0 0 24 24"
                          stroke-width="1.5"
                          stroke="currentColor"
                          class="w-6 h-6"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
                          />
                        </svg>

                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">
                            <p>
                              <%= track_playlists.track.title %>
                            </p>
                          </p>
                          <p class="text-sm text-gray-500 dark:text-gray-300 truncate">
                            <%= live_redirect(track_playlists.track.user.username,
                              to:
                                Routes.profile_index_path(
                                  @socket,
                                  :index,
                                  track_playlists.track.user.username
                                )
                            ) %>
                          </p>
                        </div>
                      </div>
                    </button>
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
