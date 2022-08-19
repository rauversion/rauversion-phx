defmodule RauversionWeb.ArticlesLive.CategoriesSectionComponent do
  use RauversionWeb, :live_component

  alias Rauversion.{Posts}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:posts, list_posts_on_category(assigns.category_slug))}
  end

  defp list_posts_on_category(slug) do
    category = Rauversion.Categories.get_category_by_slug!(slug)

    Posts.list_posts("published")
    |> Posts.with_category(category)
    |> Rauversion.Repo.paginate(page: 1, page_size: 3)
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="border-white border-t border-b flex items-center">
        <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl py-4">
          Reviews
        </h2>
      </div>

      <div class="flex space-x-2">
        <%= for post <- @posts do %>
          <div class="w-full px-2 mt-12 md:w-1/2 lg:w-1/4">
            <.live_component
              id={"post-id-#{post.id}"}
              module={RauversionWeb.ArticlesLive.ArticlesBlockComponent}
              post={post}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
