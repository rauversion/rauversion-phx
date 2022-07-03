defmodule RauversionWeb.PlaylistLive.CreateFormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""

    <div class="space-y-8 divide-y divide-gray-200 sm:space-y-5">
      <div class="mx-2 py-6">
        <div class="relative bg-white">

          <nav class="flex space-x-4" aria-label="Tabs" data-controller="tabs">
            <a href="#" data-tab="#share-tab" data-action="click->tabs#changeTab" class="tab-link bg-orange-100 text-orange-700 px-3 py-2 font-medium text-sm rounded-md"> Add to playlist </a>
            <a href="#" data-tab="#embed-tab" data-action="click->tabs#changeTab" class="tab-link text-orange-500 hover:text-orange-700 px-3 py-2 font-medium text-sm rounded-md"> Create a playlist </a>
          </nav>

          <section id="share-tab" class="tab-pane block py-4">
            <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
              Add to playlist
            </h2>

            <div class="sm:col-span-6">
              <div class="flow-root mt-6">
                <ul role="list" class="-my-5 divide-y divide-gray-200">
                  <li class="py-4">
                    <div class="flex items-center space-x-4">
                      <div class="flex-shrink-0">
                        <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                      </div>
                      <div class="flex-1 min-w-0">
                        <p class="text-sm font-medium text-gray-900 truncate">Leonard Krasner</p>
                        <p class="text-sm text-gray-500 truncate">@leonardkrasner</p>
                      </div>
                      <div>
                        <a href="#" class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50"> View </a>
                      </div>
                    </div>
                  </li>

                  <li class="py-4">
                    <div class="flex items-center space-x-4">
                      <div class="flex-shrink-0">
                        <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                      </div>
                      <div class="flex-1 min-w-0">
                        <p class="text-sm font-medium text-gray-900 truncate">Floyd Miles</p>
                        <p class="text-sm text-gray-500 truncate">@floydmiles</p>
                      </div>
                      <div>
                        <a href="#" class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50"> Add to playlist </a>
                      </div>
                    </div>
                  </li>
                </ul>
              </div>
              <div class="mt-6">
                <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
              </div>
            </div>

          </section>

          <section id="embed-tab" class="tab-pane hidden py-4">
            <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
              Create playlist
            </h2>


            <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
              <div class="sm:col-span-6">
                <label for="first-name" class="block text-sm font-medium text-gray-700">
                  Playlist title
                </label>
                <div class="mt-1">
                  <input type="text" name="first-name" id="first-name" autocomplete="given-name" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md">
                </div>
              </div>

              <div class="flex items-center space-x-2">

                <div class="flex items-center">
                  <label for="push-everything" class="block text-md font-bold text-gray-700">
                    Privacy
                  </label>
                </div>

                <div class="flex items-center">
                  <input id="push-everything" name="push-notifications" type="radio" class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300">
                  <label for="push-everything" class="ml-3 block text-sm font-medium text-gray-700">
                    Private
                  </label>
                </div>
                <div class="flex items-center">
                  <input id="push-email" name="push-notifications" type="radio" class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300">
                  <label for="push-email" class="ml-3 block text-sm font-medium text-gray-700">
                    Public
                  </label>
                </div>
              </div>

              <div class="sm:col-span-6">
                <div class="flow-root mt-6">
                  <ul role="list" class="-my-5 divide-y divide-gray-200">
                    <li class="py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0">
                          <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 truncate">Leonard Krasner</p>
                          <p class="text-sm text-gray-500 truncate">@leonardkrasner</p>
                        </div>
                        <div>
                          <a href="#" class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50"> View </a>
                        </div>
                      </div>
                    </li>

                    <li class="py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0">
                          <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 truncate">Floyd Miles</p>
                          <p class="text-sm text-gray-500 truncate">@floydmiles</p>
                        </div>
                        <div>
                          <a href="#" class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50"> View </a>
                        </div>
                      </div>
                    </li>

                    <li class="py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0">
                          <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1502685104226-ee32379fefbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 truncate">Emily Selman</p>
                          <p class="text-sm text-gray-500 truncate">@emilyselman</p>
                        </div>
                        <div>
                          <a href="#" class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50"> View </a>
                        </div>
                      </div>
                    </li>

                    <li class="py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0">
                          <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 truncate">Kristin Watson</p>
                          <p class="text-sm text-gray-500 truncate">@kristinwatson</p>
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

          </section>

        </div>
      </div>
    </div>

    """
  end
end
