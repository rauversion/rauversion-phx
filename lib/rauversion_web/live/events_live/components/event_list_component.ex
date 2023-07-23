defmodule RauversionWeb.EventsLive.EventsListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Events}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
    }
  end

  defp upcoming_events() do
    Events.public_events()
    |> Events.upcoming_events()
    |> Rauversion.Repo.all()
  end

  defp past_events() do
    Events.public_events()
    |> Events.past_events()
    |> Rauversion.Repo.all()
  end

  def render(assigns) do
    assigns = assign(assigns, :upcoming_events, upcoming_events())

    ~H"""
    <div class="pt-16 pb-20 px-4 sm:px-6 lg:pt-24 lg:pb-28 lg:px-8">
      <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-100 lg:max-w-7xl">
        <%= if Enum.any?(@upcoming_events) do %>
          <div>
            <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl">
              <%= gettext("Upcoming Events") %>
            </h2>
            <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 sm:mt-4">
              <%= gettext("Upcoming Events from the Rauversion community") %>
            </p>
          </div>

          <div class="">
            <div class="max-w-7xl mx-auto py-16 px-4 overflow-hidden sm:py-24 sm:px-6 lg:px-8">
              <div class="grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-3 lg:gap-x-8">
                <%= for event <- @upcoming_events do %>
                  <.link navigate={Routes.events_show_path(assigns.socket, :show, event.slug)}
                    class="group text-sm p-2 hover:bg-gray-700">
                    <div class="w-full aspect-w-1 aspect-h-1 rounded-lg overflow-hidden bg-gray-100 dark:bg-gray-900 group-hover:opacity-75">
                      <%= img_tag(
                        Rauversion.Events.Event.variant_url(event, "cover", %{
                          resize_to_limit: "500x500"
                        }),
                        class: "w-full h-full object-center object-cover"
                      ) %>
                    </div>

                    <h3 class="mt-4 font-medium text-gray-900 dark:text-gray-100">
                      <%= event.title %>
                    </h3>

                    <p class="text-gray-500 italic">
                      <%= event.province %> <%= event.city %> <%= event.country %>
                    </p>

                    <p class="mt-2 font-medium text-gray-900 dark:text-gray-100">
                      <%= Rauversion.Events.event_dates(event, @timezone) %>
                    </p>
                  </.link>
                <% end %>
              </div>
            </div>
          </div>

        <% end %>
      </div>

      <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-100 lg:max-w-7xl">
        <div>
          <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl">
            <%= gettext("Past Events") %>
          </h2>
        </div>

        <div class="">
          <div class="max-w-7xl mx-auto py-16 px-4 overflow-hidden sm:py-24 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-5 lg:gap-x-8">
              <%= for event <- past_events() do %>
                <.link navigate={Routes.events_show_path(assigns.socket, :show, event.slug)}
                  class="group text-sm p-2 hover:bg-gray-800 rounded-md transition-colors duration-500 ease-in-out">
                  <div class="w-full aspect-w-1 aspect-h-1 rounded-lg overflow-hidden bg-gray-100 dark:bg-gray-900 group-hover:opacity-75">
                    <%= img_tag(
                      Rauversion.Events.Event.variant_url(event, "cover", %{
                        resize_to_limit: "500x500"
                      }),
                      class: "w-full h-full object-center object-cover"
                    ) %>
                  </div>

                  <h3 class="mt-4 font-medium text-gray-900 dark:text-gray-100">
                    <%= event.title %>
                  </h3>

                  <p class="text-gray-500 italic">
                    <%= event.province %> <%= event.city %> <%= event.country %>
                  </p>

                  <p class="mt-2 font-medium text-gray-900 dark:text-gray-100">
                    <%= Rauversion.Events.event_dates(event, @timezone) %>
                  </p>
                </.link>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
