defmodule RauversionWeb.ArticlesLive.ArticlesListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Posts, Repo}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:posts, list_posts())}
  end

  defp list_posts() do
    Posts.list_posts("published") |> Repo.preload(user: :avatar_blob)
  end

  def render(assigns) do
    ~H"""
    <div class="bg-white dark:bg-black pt-16 pb-20 px-4 sm:px-6 lg:pt-24 lg:pb-28 lg:px-8">
      <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-700 lg:max-w-7xl">
        <div>
          <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl">Recent publications</h2>
          <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 sm:mt-4">
            Selected articles & reviews from Rauversion community and editorial
          </p>
        </div>
        <div class="mt-12 grid gap-16 pt-12 lg:grid-cols-3 lg:gap-x-5 lg:gap-y-12">

          <%= for post <- @posts do %>
            <div>
              <div>
                <a href="#" class="inline-block">
                  <span class="inline-flex items-center px-3 py-0.5 rounded-full text-sm font-medium bg-indigo-100 text-indigo-800"> Article </span>
                </a>
              </div>
              <%= live_redirect to: Routes.articles_show_path(@socket, :show, post.slug), class: "block mt-4" do %>
                <p class="text-xl font-semibold text-gray-900 dark:text-gray-100"><%= post.title %></p>
                <p class="mt-3 text-base text-gray-500 dark:text-gray-300"><%= post.excerpt %></p>
              <% end %>
              <div class="mt-6 flex items-center">
                <div class="flex-shrink-0">
                  <%= live_redirect to: Routes.profile_index_path(@socket, :index, post.user.username) do %>
                    <span class="sr-only"><%= post.user.username %></span>
                    <%= img_tag(Rauversion.Accounts.avatar_url(post.user), class: "h-10 w-10 rounded-full") %>
                  <% end %>
                </div>
                <div class="ml-3">
                  <p class="text-sm font-medium text-gray-900 dark:text-gray-100">
                    <%= live_redirect to: Routes.profile_index_path(@socket, :index, post.user.username) do %>
                      <%= post.user.username %>
                    <% end %>
                  </p>
                  <div class="flex space-x-1 text-sm text-gray-500 dark:text-gray-300">
                    <time datetime="2020-03-16"> Mar 16, 2020 </time>
                    <span aria-hidden="true"> &middot; </span>
                    <span> 6 min read </span>
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
