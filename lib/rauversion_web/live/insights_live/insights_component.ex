defmodule RauversionWeb.InsightsLive.InsightComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{profile: profile} = assigns) do
    ~H"""
      <div class="mx-auto w-3/4">
        <div class="pt-4">
          <h3 class="text-lg leading-6 font-medium text-gray-900">Last 30 days</h3>
          <dl class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Total Listens</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900">71,897</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Likes</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900">58.16%</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Reposts</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900">24.57%</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Downloads</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900">24.57%</dd>
            </div>

            <div class="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
              <dt class="text-sm font-medium text-gray-500 truncate">Comments</dt>
              <dd class="mt-1 text-3xl font-semibold text-gray-900">24.57%</dd>
            </div>
          </dl>
        </div>

        <% #= Jason.encode! CountByDateQuery.row_counts_by_month() |> Rauversion.Repo.all() |> Map.new()  %>

        <% #= Jason.encode! CountByDateQuery.row_counts_by_day() |> Rauversion.Repo.all() |> Map.new()  %>

        <% #= Jason.encode! CountByDateQuery.row_counts_by_month() |> Rauversion.Repo.all() |> Map.new()  %>

        <div>
          <div id="chart-line-container" class="shadow-lg rounded-lg overflow-hidden" phx-update="ignore" data-controller="chart">
            <div class="py-3 px-5 bg-gray-50">Line chart</div>
            <canvas class="p-10" width="400" height="200" id="chartLine"></canvas>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4">

          <div class="p-4 shadow-lg rounded-lg overflow-hidden">

            <div class="-px-4 py-5 -sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900">
                Top tracks
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Last 12 months
              </p>
            </div>


            <div class="flow-root mt-6">
              <ul role="list" class="-my-5 divide-y divide-gray-200">
                <li class="py-4">
                  <div class="flex items-center space-x-4">
                    <div class="flex-shrink-0">
                      <img class="h-8 w-8 rounded-sm" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-medium text-gray-900 truncate">Uncle Remus</p>
                      <div class="text-sm text-gray-500 space-x-2 flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
                        </svg>
                        <span>13 plays</span>
                      </div>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
            <div class="mt-6">
              <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
            </div>
          </div>


          <div class="p-4 shadow-lg rounded-lg overflow-hidden">

            <div class="-px-4 py-5 -sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900">
                Top Listeners
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Last 12 months
              </p>
            </div>

            <div class="flow-root mt-6">
              <ul role="list" class="-my-5 divide-y divide-gray-200">
                <li class="py-4">
                  <div class="flex items-center space-x-4">
                    <div class="flex-shrink-0">
                      <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-medium text-gray-900 truncate">Leonard Krasner</p>

                      <div class="text-sm text-gray-500 space-x-2 flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
                        </svg>
                        <span>13 plays</span>
                      </div>

                    </div>
                  </div>
                </li>
              </ul>
            </div>
            <div class="mt-6">
              <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
            </div>
          </div>


          <div id="gep-chart-wrapper" class="p-4 col-span-2 shadow-lg rounded-lg overflow-hidden">
            <div class="-px-4 py-5 -sm:px-6">
              <h3 class="text-lg leading-6 font-medium text-gray-900">
                Top Locations
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Personal details and application.
              </p>
            </div>

            <div class="flow-root mt-6">
              <ul role="list" class="-my-5 divide-y divide-gray-200">
                <li class="py-4">
                  <div class="flex items-center space-x-4">
                    <div class="flex-shrink-0">
                      <img class="h-8 w-12 rounded-sm" src="https://countryflagsapi.com/png/chile" alt="">
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-medium text-gray-900 truncate">Chile</p>
                      <div class="text-sm text-gray-500 space-x-2 flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
                        </svg>
                        <span>13 plays</span>
                      </div>
                    </div>
                    <div>
                      <a href="#" class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50"> View </a>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
            <div class="mt-6">
              <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
            </div>
          </div>
        </div>

      </div>
    """
  end
end
