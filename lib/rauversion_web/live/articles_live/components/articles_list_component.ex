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
    Posts.list_posts("published")
    |> Rauversion.Repo.paginate(page: 1, page_size: 3)
  end

  def render(assigns) do
    ~H"""
    <div class="pt-16 pb-20 px-4 sm:px-6 lg:pt-24 lg:pb-28 lg:px-8">
      <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-100 lg:max-w-7xl">

        <div>
          <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl">
            <%= gettext("Recent publications") %>
          </h2>

          <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 sm:mt-4">
            <%= gettext "Selected articles & reviews from Rauversion community and editorial" %>
          </p>

        </div>

        <div class="mt-12 grid gap-16 pt-12 lg:grid-cols-6 lg:gap-x-5 lg:gap-y-12">
          <div class="col-span-5 flex space-x-4 divide-x-2">

            <div class="w-1/4 space-y-4">
              <%= for post <- @posts do %>
                <.live_component
                  post={post}
                  id={"side-articles-#{post.id}"}
                  module={RauversionWeb.ArticlesLive.ArticleComponent}
                  hide_excerpt={true}
                  truncate_titlesss={true}
                />
              <% end %>
            </div>

            <div class="px-4 flex-grow space-y-4 pb-4">
              <%= for post <- @posts do %>
                <.live_component
                  id={"main-articles-#{post.id}"}
                  post={post}
                  module={RauversionWeb.ArticlesLive.ArticleComponent}
                  image_class={"h-64"}
                />
              <% end %>
            </div>

          </div>

          <div class="col-span-1 space-y-4">
            <h3 class="border-b uppercase">The Latest</h3>
            <.live_component id="b3" module={RauversionWeb.Live.ArticlesLive.ArticleSmallComponent} />
            <.live_component id="b4" module={RauversionWeb.Live.ArticlesLive.ArticleSmallComponent} />
            <.live_component id="b5" module={RauversionWeb.Live.ArticlesLive.ArticleSmallComponent} />
            <.live_component id="b6" module={RauversionWeb.Live.ArticlesLive.ArticleSmallComponent} />
            <.live_component id="b7" module={RauversionWeb.Live.ArticlesLive.ArticleSmallComponent} />
          </div>

        </div>


        <div class="border-white border-t border-b flex items-center">
          <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl py-4">
            Reviews
          </h2>
        </div>

        <div class="flex space-x-2">
          <div class="w-full px-2 mt-12 md:w-1/2 lg:w-1/4">
            <.live_component id="b71" module={RauversionWeb.ArticlesLive.ArticlesBlocksComponent} />
          </div>
          <div class="w-full px-2 mt-12 md:w-1/2 lg:w-1/4">
            <.live_component id="b72" module={RauversionWeb.ArticlesLive.ArticlesBlocksComponent} />
          </div>
          <div class="w-full px-2 mt-12 md:w-1/2 lg:w-1/4">
            <.live_component id="b73" module={RauversionWeb.ArticlesLive.ArticlesBlocksComponent} />
          </div>
          <div class="w-full px-2 mt-12 md:w-1/2 lg:w-1/4">
            <.live_component id="b74" module={RauversionWeb.ArticlesLive.ArticlesBlocksComponent} />
          </div>
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
                <p class="truncate text-xl font-semibold text-gray-900 dark:text-gray-100"><%= post.title %></p>
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
