defmodule RauversionWeb.ProfileLive.TrendingComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  @impl true
  def update(assigns, socket) do
    page = 1

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:page, page)
      |> assign(:collection, comments_list(page))
    }
  end

  defp comments_list(page) do
    Rauversion.TrackComments.list_track_comments_query()
    |> Rauversion.Repo.paginate(page: page, page_size: 5)
  end

  def render(assigns) do
    ~H"""
      <div class="bg-white border-t">
        <div class="p-6">
          <h2 id="trending-heading" class="text-base font-medium text-gray-900">
            Trending
          </h2>
          <div class="mt-6 flow-root">
            <ul role="list" class="-my-4 divide-y divide-gray-200">

              <%= for item <- assigns.collection do  %>

                <li class="flex py-4 space-x-3">
                  <div class="flex-shrink-0">
                    <%= img_tag(Rauversion.Playlists.variant_url( item.user, "avatar", %{resize_to_limit: "300x200"}),
                    class: "h-8 w-8 rounded-full")
                    %>
                  </div>
                  <%= live_redirect to: Routes.track_show_path(@socket, :show, item.track_id), class: "min-w-0 flex-1" do %>
                    <p class="text-sm text-gray-800"><%= item.body %></p>
                    <div class="mt-2 flex">
                      <span class="inline-flex items-center text-sm">
                        <button type="button" class="inline-flex space-x-2 text-gray-400 hover:text-gray-500">
                          <svg class="h-5 w-5" x-description="Heroicon name: solid/chat-alt" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                            <path fill-rule="evenodd" d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zM7 8H5v2h2V8zm2 0h2v2H9V8zm6 0h-2v2h2V8z" clip-rule="evenodd"></path>
                          </svg>
                          <span class="font-medium text-gray-900"><%= item.user.username %></span>
                        </button>
                      </span>
                    </div>
                  <% end %>
                </li>
              <% end %>

            </ul>
          </div>
          <div class="mt-6">
            <a href="#" class="w-full block text-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
              View all
            </a>
          </div>
        </div>
      </div>
    """
  end
end
