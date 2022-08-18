defmodule RauversionWeb.ArticlesLive.ArticlesHighlightsListComponent do
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
    Posts.list_posts("published")
    |> Rauversion.Repo.paginate(page: 1, page_size: 3)
  end

  def render(assigns) do
    ~H"""
    <div class="py-8 sm:py-24- lg:max-w-7xl lg:mx-auto lg:py-32- lg:px-8">
      <%= if Enum.any?(@posts) do %>
        <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-100 lg:max-w-7xl">
          <div>
            <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl"><%= gettext("Recent publications") %></h2>
            <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 sm:mt-4">
              <%= gettext "Selected articles & reviews from Rauversion community and editorial" %>
            </p>

          </div>

          <div class="container pb-4 mx-auto px-5- md:px-12- lg:px-16-">
            <div class="flex flex-wrap">
              <%= for post <- @posts do %>
                <div class="w-full px-2 mt-12 md:w-1/2 lg:w-1/3">
                  <div class="relative flex flex-wrap items-end w-full dark:text-white">

                    <%= img_tag(Rauversion.Tracks.variant_url(
                      post, "cover", %{resize_to_limit: "360x360"}),
                      class: "inset-0 block object-cover object-center w-full h-72 grayscale filter")
                    %>

                    <div class="items-end w-full mt-4 text-left">
                      <%= live_redirect to: Routes.articles_show_path(@socket, :show, post.slug) do %>
                        <h2 class="truncate mb-2 font-serif text-xl font-semibold text-black dark:text-white lg:text-2xl">
                          <%= post.title %>
                        </h2>
                      <% end %>
                      <strong class="text-xs font-bold leading-relaxed tracking-widest uppercase">
                        by <%= post.user.username %> · FEBRUARI 25, 2020.
                      </strong>
                      <p class="mt-4 text-sm tracking-wide  text-ellipsis overflow-hidden h-16">
                        <%= post.excerpt %>
                      </p>
                      <%= live_redirect to: Routes.articles_show_path(@socket, :show, post.slug), class: "inline-flex items-center py-4 mt-3 text-xs font-bold tracking-widest text-black uppercase transition duration-500 ease-in-out transform border-b-2 border-black dark:border-white dark:text-white hover:text-gray-600 hover:border-gray-600" do %>
                        Listen Now
                        <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="w-4 h-4 ml-2" viewBox="0 0 24 24">
                          <path d="M5 12h14M12 5l7 7-7 7"></path>
                        </svg>
                      <% end %>
                    </div>
                  </div>
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
