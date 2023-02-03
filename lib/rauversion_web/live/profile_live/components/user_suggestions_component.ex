defmodule RauversionWeb.ProfileLive.UserSuggestionComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Accounts, UserFollows, Repo}

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:collection, who_to_follow(assigns.current_user))
    }
  end

  defp who_to_follow(current_user) do
    Accounts.unfollowed_artists(current_user)
    |> Repo.paginate(page: 1, page_size: 5)

    # |> Rauversion.Repo.preload(:avatar_blob)
  end

  @impl true
  def handle_event("follow-account", %{"id" => id}, socket) do
    UserFollows.create_user_follow(%{
      follower_id: socket.assigns.current_user.id,
      following_id: id
    })

    {:noreply, socket |> assign(:collection, who_to_follow(socket.assigns.current_user))}
  end

  @impl true
  def render(%{collection: _collection} = assigns) do
    ~H"""
      <section aria-labelledby="who-to-follow-heading">
        <div class="bg-white border-t dark:bg-gray-900 dark:border-gray-800">
          <div class="p-6">
            <h2 id="who-to-follow-heading" class="text-base font-medium text-gray-900 dark:text-gray-100">
            <%= gettext("Who to follow") %>
            </h2>
            <div class="mt-6 flow-root">
              <ul role="list" class="-my-4 divide-y divide-gray-200 dark:divide-gray-800 dark:divide-gray-800">

                <%= for item <- @collection do %>
                  <li class="flex items-center py-4 space-x-3">
                    <div class="flex-shrink-0">

                      <%= img_tag(
                        Accounts.avatar_url(item, :small),
                        class: "h-8 w-8 rounded-full") %>

                    </div>
                    <div class="min-w-0 flex-1">
                      <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
                        <%= live_redirect "#{item.first_name} #{item.last_name}", to: Routes.profile_index_path(@socket, :index, item.username) %>
                      </p>
                      <p class="text-sm text-gray-500">
                        <%= live_redirect "#{item.username}", to: Routes.profile_index_path(@socket, :index, item.username) %>
                      </p>
                    </div>
                    <div class="flex-shrink-0">
                      <%= link to: "#",  phx_click: "follow-account", phx_value_id: item.id, phx_target: @myself, class: "inline-flex items-center px-3 py-0.5 rounded-full bg-rose-50 dark:bg-rose-900 text-sm font-medium text-rose-700 dark:text-rose-300 hover:bg-rose-100 dark:hover:bg-rose-900" do %>
                        <svg class="-ml-1 mr-0.5 h-5 w-5 text-rose-400" x-description="Heroicon name: solid/plus-sm" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                          <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd"></path>
                        </svg>
                        <span>
                        <%= gettext "Follow" %>
                        </span>
                      <% end %>
                    </div>
                  </li>
                <% end %>

              </ul>
            </div>
            <div class="mt-6 hidden">
              <a href="#" class="w-full block text-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50  dark:text-gray-300 dark:bg-black dark:hover:bg-gray-900">
              <%= gettext "View all" %>
              </a>
            </div>
          </div>
        </div>
      </section>
    """
  end
end
