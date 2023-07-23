defmodule RauversionWeb.MySalesLive.Index do
  use RauversionWeb, :live_view

  defp get_items() do
    [
      # %{href: "/sales/tickets", name: "Tickets"},
      %{href: "/sales/music", name: "Music"}
    ]
  end

  defp icon_for(_kind = "Tickets") do
    assigns = %{}

    ~H"""
    <svg
      class="h-10 w-10 flex-shrink-0 rounded-full text-gray-800 dark:text-gray-100"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M16.5 6v.75m0 3v.75m0 3v.75m0 3V18m-9-5.25h5.25M7.5 15h3M3.375 5.25c-.621 0-1.125.504-1.125 1.125v3.026a2.999 2.999 0 010 5.198v3.026c0 .621.504 1.125 1.125 1.125h17.25c.621 0 1.125-.504 1.125-1.125v-3.026a2.999 2.999 0 010-5.198V6.375c0-.621-.504-1.125-1.125-1.125H3.375z"
      />
    </svg>
    """
  end

  defp icon_for(_kind = "Music") do
    assigns = %{}

    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M9 9l10.5-3m0 6.553v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 11-.99-3.467l2.31-.66a2.25 2.25 0 001.632-2.163zm0 0V2.25L9 5.25v10.303m0 0v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 01-.99-3.467l2.31-.66A2.25 2.25 0 009 15.553z"
      />
    </svg>
    """
  end

  def render(assigns) do
    ~H"""
    <div>
      <header class="bg-gray-50 dark:bg-gray-900 py-8">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 xl:flex xl:items-center xl:justify-between">
          <div class="min-w-0 flex-1">
            <h1 class="mt-2 text-2xl font-bold leading-7 text-gray-900 dark:text-gray-100 dark:text-gray-100 sm:truncate sm:text-3xl sm:tracking-tight">
              <%= gettext("My Sales") %>
            </h1>
          </div>
        </div>
      </header>

      <div class="mx-auto max-w-7xl sm:px-6 lg:px-8 py-10">
        <ul role="list" class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <%= for item <- get_items() do %>
            <li class="col-span-1 divide-y divide-gray-200 rounded-lg bg-white dark:bg-gray-800 dark:hover:bg-gray-700 shadow">
              <%= live_redirect to: "#{item[:href]}" do %>
                <div class="flex w-full items-center justify-between space-x-6 p-6">
                  <div class="flex-1 truncate">
                    <div class="flex items-center space-x-3">
                      <h3 class="truncate text-sm font-medium text-gray-900 dark:text-gray-100">
                        <%= item[:name] %>
                      </h3>
                      <span class="inline-block flex-shrink-0 rounded-full bg-green-100 px-2 py-0.5 text-xs font-medium text-green-800">
                        Admin
                      </span>
                    </div>
                    <p class="mt-1 truncate text-sm text-gray-500 dark:text-gray-300">
                      <%= gettext("Your %{name} Sales", name: item[:name]) %>
                    </p>
                  </div>

                  <%= icon_for(item[:name]) %>
                </div>
              <% end %>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
