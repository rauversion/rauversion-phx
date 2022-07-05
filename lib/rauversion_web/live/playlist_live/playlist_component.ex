defmodule RauversionWeb.PlaylistLive.PlaylistComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    IO.inspect(assigns)

    ~H"""
      <div class="my-2 p-2 border shadow-xs mx-3">
        <div class="flex space-x-3">
          <div class="w-32 h-32 bg-red-600"></div>
          <div class="flex-grow space-y-2">
            <h3 class="mt-3- text-xl font-extrabold tracking-tight text-slate-900">
              <%= @playlist.title %>
            </h3>
            <ul role="list" class="-my-5 divide-y divide-gray-200">
              <%= for track_playlists <- @playlist.track_playlists do %>
                <li class="py-4">
                  <div class="flex items-center space-x-4">
                    <div class="flex-shrink-0">
                      <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-medium text-gray-900 truncate"><%= track_playlists.track.title %></p>
                      <p class="text-sm text-gray-500 truncate">@leonardkrasner</p>
                    </div>
                    <div>
                      <a href="#" phx-click="remove-track" target={@myself} class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                        remove
                      </a>
                    </div>
                  </div>
                </li>
              <% end %>
            </ul>
          </div>
        </div>
      </div>
    """
  end
end
