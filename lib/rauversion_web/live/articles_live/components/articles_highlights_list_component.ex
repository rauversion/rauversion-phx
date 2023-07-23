defmodule RauversionWeb.ArticlesLive.ArticlesHighlightsListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Posts}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:posts, list_posts())}
  end

  defp list_posts() do
    Posts.list_posts("published")
    |> Posts.order()
    |> Rauversion.Repo.paginate(page: 1, page_size: 3)
  end

  def render(assigns) do
    ~H"""
    <div class="py-8 sm:py-24- lg:max-w-7xl lg:mx-auto lg:py-32- lg:px-8">
      <%= if Enum.any?(@posts) do %>
        <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-100 lg:max-w-7xl">
          <div class="mx-2 sm:mx-0">
            <h2 class="text-xl sm:text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl">
              <%= gettext("Recent publications") %>
            </h2>
            <div class="px-4 flex items-center justify-between sm:px-6 lg:px-0">
              <h2 id="trending-heading" class="mt-3 text-sm sm:text-xl text-gray-500 dark:text-gray-300 sm:mt-4">
                <%= gettext("Selected articles & reviews from Rauversion community and editorial") %>
              </h2>
              <a href="/tracks" class="hidden sm:block text-sm font-semibold text-brand-600 hover:text-brand-500" data-phx-link="redirect" data-phx-link-state="push">
                See everything
                <span aria-hidden="true"> →</span>
              </a>
            </div>
          </div>

          <div class="container pb-4 mx-auto px-5- md:px-12- lg:px-16-">
            <div class="flex flex-wrap">
              <%= for post <- @posts do %>
                <div class="w-full px-2 mt-12 md:w-1/2 lg:w-1/3">
                  <.live_component
                    post={post}
                    id={"post-#{post.id}"}
                    module={RauversionWeb.ArticlesLive.ArticlesBlockComponent}
                  />
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
