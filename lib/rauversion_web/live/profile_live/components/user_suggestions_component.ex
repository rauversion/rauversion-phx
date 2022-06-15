defmodule RauversionWeb.ProfileLive.UserSuggestionComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{track: track} = assigns) do
    ~H"""
      <section aria-labelledby="who-to-follow-heading">
        <div class="bg-white border-t">
          <div class="p-6">
            <h2 id="who-to-follow-heading" class="text-base font-medium text-gray-900">
              Who to follow
            </h2>
            <div class="mt-6 flow-root">
              <ul role="list" class="-my-4 divide-y divide-gray-200">

                <%= for item <- Rauversion.Accounts.list_accounts(5) do %>
                  <li class="flex items-center py-4 space-x-3">
                    <div class="flex-shrink-0">
                      <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=facearea&amp;facepad=2&amp;w=256&amp;h=256&amp;q=80" alt="">
                    </div>
                    <div class="min-w-0 flex-1">
                      <p class="text-sm font-medium text-gray-900">
                        <a href="#"><%= item.first_name %> <%= item.last_name %></a>
                      </p>
                      <p class="text-sm text-gray-500">
                        <a href="#">@<%= item.username %></a>
                      </p>
                    </div>
                    <div class="flex-shrink-0">
                      <button type="button" class="inline-flex items-center px-3 py-0.5 rounded-full bg-rose-50 text-sm font-medium text-rose-700 hover:bg-rose-100">
                        <svg class="-ml-1 mr-0.5 h-5 w-5 text-rose-400" x-description="Heroicon name: solid/plus-sm" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                          <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd"></path>
                        </svg>
                        <span>
                          Follow
                        </span>
                      </button>
                    </div>
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
      </section>
    """
  end
end
