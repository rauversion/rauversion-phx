defmodule RauversionWeb.EventsLive.EventsListComponent do
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
    <div class="pt-16 pb-20 px-4 sm:px-6 lg:pt-24 lg:pb-28 lg:px-8">
      <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-700 lg:max-w-7xl">
        <div>
          <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl"><%= gettext("Upcoming Events") %></h2>
          <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 sm:mt-4">
            <%= gettext "Selected articles & reviews from Rauversion community and editorial" %>
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



        <div class="bg-white dark:bg-black">
          <div class="max-w-7xl mx-auto py-16 px-4 overflow-hidden sm:py-24 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-3 lg:gap-x-8">
              <a href="#" class="group text-sm">
                <div class="w-full aspect-w-1 aspect-h-1 rounded-lg overflow-hidden bg-gray-100 dark:bg-gray-900 group-hover:opacity-75">
                  <img src="https://tailwindui.com/img/ecommerce-images/category-page-07-product-01.jpg" alt="White fabric pouch with white zipper, black zipper pull, and black elastic loop." class="w-full h-full object-center object-cover">
                </div>
                <h3 class="mt-4 font-medium text-gray-900 dark:text-gray-100">Nomad Pouch</h3>
                <p class="text-gray-500 italic">White and Black</p>
                <p class="mt-2 font-medium text-gray-900 dark:text-gray-100">$50</p>
              </a>

              <a href="#" class="group text-sm">
                <div class="w-full aspect-w-1 aspect-h-1 rounded-lg overflow-hidden bg-gray-100 dark:bg-gray-900 group-hover:opacity-75">
                  <img src="https://tailwindui.com/img/ecommerce-images/category-page-07-product-02.jpg" alt="Front of tote bag with washed black canvas body, black straps, and tan leather handles and accents." class="w-full h-full object-center object-cover">
                </div>
                <h3 class="mt-4 font-medium text-gray-900 dark:text-gray-100">Zip Tote Basket</h3>
                <p class="text-gray-500 italic">Washed Black</p>
                <p class="mt-2 font-medium text-gray-900 dark:text-gray-100">$140</p>
              </a>

              <a href="#" class="group text-sm">
                <div class="w-full aspect-w-1 aspect-h-1 rounded-lg overflow-hidden bg-gray-100 dark:bg-gray-900 group-hover:opacity-75">
                  <img src="https://tailwindui.com/img/ecommerce-images/category-page-07-product-03.jpg" alt="Front of satchel with blue canvas body, black straps and handle, drawstring top, and front zipper pouch." class="w-full h-full object-center object-cover">
                </div>
                <h3 class="mt-4 font-medium text-gray-900 dark:text-gray-100">Medium Stuff Satchel</h3>
                <p class="text-gray-500 italic">Blue</p>
                <p class="mt-2 font-medium text-gray-900 dark:text-gray-100">$220</p>
              </a>

              <!-- More products... -->
            </div>
          </div>
        </div>



      </div>
    </div>
    """
  end
end
