defmodule RauversionWeb.ArticlesLive.ArticleComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Posts, Repo}

  def render(assigns) do
    image_height_class = assigns |> Map.get(:image_class) || "h-32"

    ~H"""
    <div class="cursor-pointer group">
      <div class="relative overflow-hidden transition-all bg-gray-100 rounded-md dark:bg-gray-800 hover:scale-105 aspect-square">
        <%= live_redirect to: Routes.articles_show_path(@socket, :show, @post.slug) , class: "block w-full #{image_height_class}" do %>
          <span style="box-sizing: border-box; display: block; overflow: hidden; width: initial; height: initial; background: none; opacity: 1; border: 0px; margin: 0px; padding: 0px; position: absolute; inset: 0px;">
          <%= img_tag(Rauversion.Tracks.variant_url(
            @post, "cover", %{resize_to_limit: "360x360"}),
            class: "transition-all",
            style: "position: absolute; inset: 0px; box-sizing: border-box; padding: 0px; border: none; margin: auto; display: block; width: 0px; height: 0px; min-width: 100%; max-width: 100%; min-height: 100%; max-height: 100%; object-fit: cover;"
          )
          %>
         </span>
        <% end %>
      </div>

      <div>
        <%= live_redirect to: Routes.articles_show_path(@socket, :show, @post.slug) do %>
          <span class="inline-block mt-5 text-xs font-medium tracking-wider uppercase  text-emerald-700">
            Personal Growth
          </span>
        <% end %>
      </div>

      <h2 class="mt-2 text-lg font-semibold tracking-normal text-brand-primary dark:text-white">
        <span class={" #{if assigns[:truncate_title], do: "truncate"} bg-gradient-to-r from-green-200 to-green-100 dark:from-purple-800 dark:to-purple-900 bg-[length:0px_10px] bg-left-bottom bg-no-repeat transition-[background-size] duration-500 hover:bg-[length:100%_3px] group-hover:bg-[length:100%_10px]"}>
        <%= @post.title %>
        </span>
      </h2>

      <div class={ if assigns[:hide_excerpt], do: "hidden" }>
        <p class="mt-2 text-sm text-gray-500 dark:text-gray-400 line-clamp-3">
          <%= live_redirect to: Routes.articles_show_path(@socket, :show, @post.slug) do %>
            <%= @post.excerpt %>
          <% end %>
        </p>
      </div>

      <div class="flex items-center mt-3 space-x-3 text-gray-500 dark:text-gray-400">
        <div class="flex items-center gap-3">
          <div class="relative flex-shrink-0 w-5 h-5">
            <span style="box-sizing: border-box; display: block; overflow: hidden; width: initial; height: initial; background: none; opacity: 1; border: 0px; margin: 0px; padding: 0px; position: absolute; inset: 0px;">

            <%= img_tag(Rauversion.Tracks.variant_url(
              @post.user, "avatar", %{resize_to_limit: "30x30"}),
              class: "rounded-full",
              )
            %>

            </span>
          </div>
          <span class="text-sm"><%= @post.user.username %></span>
        </div>
        <span class="text-xs text-gray-300 dark:text-gray-600">•</span>
        <time class="text-sm" datetime="2022-05-20T09:33:00Z">
          May 20, 2022
        </time>
      </div>

    </div>
    """
  end
end
