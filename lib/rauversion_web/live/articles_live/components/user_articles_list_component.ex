defmodule RauversionWeb.ArticlesLive.UserArticlesListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.Posts

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tab, "draft")
     |> assign(:posts, list_posts(assigns.current_user, "draft"))}
  end

  def handle_event("all" = tab, %{}, socket) do
    {:noreply,
     assign(socket, tab: tab)
     |> assign(:posts, list_posts(socket.assigns.current_user, tab))}
  end

  def handle_event("draft" = tab, %{}, socket) do
    {:noreply,
     assign(socket, tab: tab)
     |> assign(:posts, list_posts(socket.assigns.current_user, tab))}
  end

  def handle_event("published" = tab, %{}, socket) do
    {:noreply,
     assign(socket, tab: tab)
     |> assign(:posts, list_posts(socket.assigns.current_user, tab))}
  end

  defp list_posts(user, tab) do
    case tab do
      "draft" ->
        Posts.list_posts(user |> Ecto.assoc(:articles), "draft")
        |> Rauversion.Repo.paginate(page: 1, page_size: 30)

      "published" ->
        Posts.list_posts(user |> Ecto.assoc(:articles), "published")
        |> Rauversion.Repo.paginate(page: 1, page_size: 30)

      "all" ->
        Posts.list_posts(user |> Ecto.assoc(:articles), nil)
        |> Rauversion.Repo.paginate(page: 1, page_size: 30)
    end
  end

  defp tab_class(selected) do
    cond do
      selected == true ->
        "border-brand-500 text-brand-600 whitespace-nowrap py-4 px-1 border-b-2 font-medium"

      true ->
        "border-transparent text-gray-500 dark:text-gray-300 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium"
    end
  end

  def render(assigns) do
    ~H"""
    <div class="px-4 sm:px-6 lg:px-8">


      <div class="mb-6 my-4">
        <div class="">
          <div class="border-b--- border-gray-200 dark:border-gray-700">
            <nav class="-mb-px flex space-x-8 text-2xl" aria-label="Tabs">
              <a href="#" phx-click={"all"} phx-target={@myself}
              class={tab_class(@tab == "all")}>
                <%= gettext "My Articles" %>
              </a>

              <a href="#" phx-click={"draft"} phx-target={@myself}
              class={tab_class(@tab == "draft")}>
                <%= gettext "Drafts" %>
              </a>

              <a href="#" phx-click={"published"} phx-target={@myself}
              class={tab_class(@tab == "published")}>
                <%= gettext "Published" %>
              </a>

            </nav>
          </div>
        </div>
      </div>


      <div class="sm:flex sm:items-center">
        <div class="sm:flex-auto">
          <h1 class="text-xl font-semibold text-gray-900 dark:text-gray-100"><%= String.capitalize(@tab) %> Articles</h1>
          <p class="mt-2 text-sm text-gray-700 dark:text-gray-300"><%= gettext "Your articles." %></p>
        </div>
        <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
          <%= live_redirect "New article", to: Routes.articles_new_path(@socket, :new),
            class: "inline-flex items-center justify-center rounded-md border border-transparent bg-brand-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 sm:w-auto"
          %>
        </div>
      </div>
      <div class="mt-8 flex flex-col">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-300 dark:text-gray-700">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-200 dark:bg-gray-900">Title</th>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-200 dark:bg-gray-900">Author</th>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-200 dark:bg-gray-900">Status</th>
                    <th scope="col" class="relative py-3 pl-3 pr-4 sm:pr-6 dark:text-gray-200 dark:bg-gray-900 ">
                      <span class="sr-only"><%= gettext "Edit" %></span>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 dark:divide-gray-800 bg-white dark:bg-black">
                  <%= for post <- @posts do %>
                    <tr>
                      <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 dark:text-gray-200 dark:bg-gray-900 sm:pl-6">
                        <%= post.title || "-- untitled --Access" %>
                      </td>

                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-200 dark:bg-gray-900">
                        <%= post.user.username %>
                      </td>
                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-200 dark:bg-gray-900">
                        <%= post.state %>
                      </td>
                      <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6 dark:text-gray-200 dark:bg-gray-900 divide-x space-x-2">
                        <%= live_redirect to: Routes.articles_new_path(@socket, :edit, post.id), class: "text-brand-600 hover:text-brand-900" do %>
                          <%= gettext "Edit" %>
                        <% end %>

                        <%= live_redirect to: Routes.articles_show_path(@socket, :show, post.slug), class: "text-brand-600 hover:text-brand-900 pl-2" do %>
                          <%= gettext "View Article" %>
                        <% end %>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>



    """
  end
end
