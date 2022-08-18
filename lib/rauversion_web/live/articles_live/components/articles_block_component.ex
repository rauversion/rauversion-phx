defmodule RauversionWeb.ArticlesLive.ArticlesBlocksComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Posts, Repo}

  def render(assigns) do
    ~H"""

        <div class="relative flex flex-wrap items-end w-full dark:text-white">
          <img
            alt="gallery"
            class="inset-0 block object-cover object-center w-full h-72 grayscale filter"
            src="https://images.unsplash.com/photo-1581368087049-7034ed0d1e6f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cG9kY2FzdHxlbnwwfDF8MHx8&amp;ixlib=rb-1.2.1&amp;auto=format&amp;fit=crop&amp;w=500&amp;q=60"
          >
          <div class="items-end w-full mt-4 text-left">
            <%= live_redirect to: Routes.articles_show_path(@socket, :show, "post.slug") do %>
              <h2 class="truncate mb-2 font-serif text-xl font-semibold text-black dark:text-white lg:text-2xl">
                <%= "post.title" %>
              </h2>
            <% end %>
            <strong class="text-xs font-bold leading-relaxed tracking-widest uppercase">
              by <%= "post.user.username" %> · FEBRUARI 25, 2020.
            </strong>
            <p class="mt-4 text-sm tracking-wide  text-ellipsis overflow-hidden h-16">
              <%= "post.excerpt" %>
            </p>
            <%= live_redirect to: Routes.articles_show_path(@socket, :show, "post.slug"), class: "inline-flex items-center py-4 mt-3 text-xs font-bold tracking-widest text-black uppercase transition duration-500 ease-in-out transform border-b-2 border-black dark:border-white dark:text-white hover:text-gray-600 hover:border-gray-600" do %>
              Listen Now
              <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="w-4 h-4 ml-2" viewBox="0 0 24 24">
                <path d="M5 12h14M12 5l7 7-7 7"></path>
              </svg>
            <% end %>
          </div>
        </div>

    """
  end
end
