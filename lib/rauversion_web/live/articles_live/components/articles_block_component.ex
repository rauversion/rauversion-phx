defmodule RauversionWeb.ArticlesLive.ArticlesBlockComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="relative flex flex-wrap items-end w-full dark:text-white">
      <.link navigate={Routes.articles_show_path(@socket, :show, @post.slug)} class="w-full">
        <%= img_tag(
          Rauversion.Posts.proxy_cover_representation_url(@post, %{resize_to_limit: "500x500"}),
          class: "inset-0 block object-cover object-center w-full h-72 grayscale filter"
        ) %>
      </.link>

      <div class="items-end w-full mt-4 text-left">
        <.link navigate={Routes.articles_show_path(@socket, :show, @post.slug)}>
          <h2 class="truncate mb-2 font-serif text-xl font-semibold text-black dark:text-white lg:text-2xl">
            <%= @post.title %>
          </h2>
        </.link>

        <strong class="text-xs font-bold leading-relaxed tracking-widest uppercase">
          <%= gettext("by") %> <%= @post.user.username %> · <%= Rauversion.Posts.date(@post.inserted_at, :y_mm_md) %>.
        </strong>

        <p class="mt-4 text-sm tracking-wide  text-ellipsis overflow-hidden h-10">
          <%= @post.excerpt %>
        </p>

        <.link navigate={Routes.articles_show_path(@socket, :show, @post.slug)} class="inline-flex items-center py-4 mt-3 text-xs font-bold tracking-widest text-black uppercase transition duration-500 ease-in-out transform border-b-2 border-black dark:border-white dark:text-white hover:text-gray-600 hover:border-gray-600">
          <%= gettext("Read Now") %>
          <svg
            fill="none"
            stroke="currentColor"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            class="w-4 h-4 ml-2"
            viewBox="0 0 24 24"
          >
            <path d="M5 12h14M12 5l7 7-7 7"></path>
          </svg>
        </.link>
      </div>
    </div>
    """
  end
end
