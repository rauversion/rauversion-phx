defmodule RauversionWeb.InsightsLive.InsightComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{profile: _profile} = assigns) do
    ~H"""
      <div class="mx-auto w-3/4">
        <div class="pt-4">
          <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">Last 30 days</h3>
          <dl class="hidden mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Total Listens</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900 dark:text-gray-100">71,897</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Likes</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900 dark:text-gray-100">58.16%</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Reposts</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900 dark:text-gray-100">24.57%</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Downloads</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900 dark:text-gray-100">24.57%</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Comments</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900 dark:text-gray-100">24.57%</dd>
            </div>
          </dl>
        </div>

        <div>
          <div id="chart-line-container"
            class="shadow-lg rounded-lg overflow-hidden"
            phx-update="ignore"
            data-controller="chart"
            data-chart-label-value="Last 12 months"
            data-chart-points-value={Jason.encode!( CountByDateQuery.series_by_month(@profile.id) |> Rauversion.Repo.all())}>
            <canvas class="p-10" width="400" height="200" id="chartLine"></canvas>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4">

          <div class="p-4 shadow-lg rounded-lg overflow-hidden bg-gray-900">

            <div class="-px-4 py-5 -sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                Top tracks
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Last 12 months
              </p>
            </div>


            <div class="flow-root mt-6">
              <ul role="list" class="-my-5 divide-y divide-gray-200 dark:divide-gray-700">
                <%= for item <- CountByDateQuery.top_tracks(@profile.id) do %>
                  <li class="py-4">
                    <div class="flex items-center space-x-4">
                      <div class="flex-shrink-0">

                        <%= img_tag(Rauversion.Tracks.variant_url(
                          item.track, "cover", %{resize_to_limit: "360x360"}),
                          class: "h-8 w-8 rounded-xs")
                        %>
                      </div>
                      <div class="flex-1 min-w-0">
                        <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate"><%= item.title %> </p>

                        <div class="text-sm text-gray-500 space-x-2 flex items-center">
                          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
                          </svg>
                          <span><%= item.count %> plays</span>
                        </div>

                      </div>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
            <div class="mt-6 hidden">
              <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
            </div>
          </div>


          <div class="p-4 shadow-lg rounded-lg overflow-hidden bg-gray-900">

            <div class="-px-4 py-5 -sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                Top Listeners
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Last 12 months
              </p>
            </div>

            <div class="flow-root mt-6">
              <ul role="list" class="-my-5 divide-y divide-gray-200 dark:divide-gray-700">
                <%= for item <- CountByDateQuery.top_listeners(@profile.id) do %>
                  <li class="py-4">
                    <div class="flex items-center space-x-4">
                      <div class="flex-shrink-0">
                        <%= img_tag(Rauversion.Accounts.avatar_url(item.user), class: "h-8 w-8 rounded-full") %>
                      </div>
                      <div class="flex-1 min-w-0">
                        <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate"><%= item.user.username %> </p>

                        <div class="text-sm text-gray-500 space-x-2 flex items-center">
                          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
                          </svg>
                          <span><%= item.count %> plays</span>
                        </div>

                      </div>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
            <div class="mt-6 hidden">
              <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
            </div>
          </div>


          <div id="gep-chart-wrapper" class="p-4 col-span-2 shadow-lg rounded-lg overflow-hidden bg-gray-900">
            <div class="-px-4 py-5 -sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                Top Locations
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Personal details and application.
              </p>
            </div>

            <div class="flow-root mt-6">
              <ul role="list" class="-my-5 divide-y divide-gray-200 dark:divide-gray-700">
                <%= for item <- CountByDateQuery.top_countries(@profile.id) do %>
                  <li class="py-4">
                    <div class="flex items-center space-x-4">
                      <div class="flex-shrink-0">
                        <%= if item.country do %>
                          <img
                            class="h-8 w-12 rounded-sm"
                            src={"https://countryflagsapi.com/png/#{item.country}"}
                            alt="">
                        <% end %>
                      </div>
                      <div class="flex-1 min-w-0">
                        <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate"><%= Rauversion.Events.Event.country_name(item.country) || "unknown" %></p>
                        <div class="text-sm text-gray-500 space-x-2 flex items-center">
                          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
                          </svg>
                          <span><%= item.count %> plays</span>
                        </div>
                      </div>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
            <div class="mt-6 hidden">
              <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
            </div>
          </div>
        </div>

      </div>
    """
  end
end
