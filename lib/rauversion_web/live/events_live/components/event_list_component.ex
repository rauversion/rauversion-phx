defmodule RauversionWeb.EventsLive.EventsListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Events, Repo}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  defp list_posts() do
    Events.public_events()
    |> Rauversion.Repo.all()
  end

  def render(assigns) do
    ~H"""
    <div class="pt-16 pb-20 px-4 sm:px-6 lg:pt-24 lg:pb-28 lg:px-8">
      <div class="relative max-w-lg mx-auto divide-y-2 divide-gray-200 dark:divide-gray-100 lg:max-w-7xl">
        <div>
          <h2 class="text-3xl tracking-tight font-extrabold text-gray-900 dark:text-gray-100 sm:text-4xl"><%= gettext("Upcoming Events") %></h2>
          <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 sm:mt-4">
            <%= gettext "Upcoming Events from the Rauversion community" %>
          </p>
        </div>

        <div class="bg-white dark:bg-black">
          <div class="max-w-7xl mx-auto py-16 px-4 overflow-hidden sm:py-24 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-3 lg:gap-x-8">

              <%= for event <- list_posts() do %>

                <%= live_redirect to: Routes.events_show_path(assigns.socket, :show, event.slug), class: "group text-sm" do %>
                  <div class="w-full aspect-w-1 aspect-h-1 rounded-lg overflow-hidden bg-gray-100 dark:bg-gray-900 group-hover:opacity-75">
                    <%= img_tag(Rauversion.Events.Event.variant_url( event, "cover", %{resize_to_limit: "500x500"}), class: "w-full h-full object-center object-cover") %>
                  </div>

                  <h3 class="mt-4 font-medium text-gray-900 dark:text-gray-100">
                    <%= event.title %>
                  </h3>

                  <p class="text-gray-500 italic">
                    <%= event.province %> <%= event.city %> <%= event.country %>
                  </p>

                  <p class="mt-2 font-medium text-gray-900 dark:text-gray-100">
                    <%= Rauversion.Events.event_dates(event) %>
                  </p>
                <% end %>

              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
