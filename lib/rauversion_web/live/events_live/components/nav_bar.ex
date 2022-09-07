defmodule RauversionWeb.EventsLive.NavBar do
  # use Phoenix.Component
  use RauversionWeb, :live_component

  def menu_items(event) do
    [
      %{
        to: "/events/#{event.slug}/edit",
        namespace: :edit,
        title: gettext("Edit event"),
        sub: gettext("Basic Account Information.")
      },
      %{
        to: "/events/#{event.slug}/edit/schedule",
        namespace: :schedule,
        title: gettext("Schedule"),
        sub: gettext("Basic Account Information.")
      },
      %{
        to: "/events/#{event.slug}/edit/tickets",
        namespace: :tickets,
        title: gettext("Tickets"),
        sub: gettext("Change Email information.")
      },
      %{
        to: "/events/#{event.slug}/edit/widgets",
        namespace: :widgets,
        title: gettext("Widgets"),
        sub: gettext("Change your credentials")
      },
      %{
        to: "/events/#{event.slug}/edit/tax",
        namespace: :tax,
        title: gettext("Tax"),
        sub: gettext("Change your notification preferences.")
      },
      %{
        to: "/events/#{event.slug}/edit/attendees",
        namespace: :attendees,
        title: gettext("Attendees"),
        sub: gettext("Change your notification preferences.")
      },
      %{
        to: "/events/#{event.slug}/edit/email_attendees",
        namespace: :email_attendees,
        title: gettext("Email Attendees"),
        sub: gettext("Change your notification preferences.")
      },
      %{
        to: "/events/#{event.slug}/edit/sponsors",
        namespace: :sponsors,
        title: gettext("Promoters"),
        sub: gettext("Change your notification preferences.")
      }
    ]
  end

  def item_class(action, kind) do
    if action == kind do
      "bg-white text-gray-900 dark:bg-black dark:text-gray-100 bg-gray-50 bg-opacity-50-- flex p-6 border-b border-gray-gray-200 dark:border-gray-800"
    else
      "bg-gray-100 text-gray-900 dark:bg-gray-900 dark:text-gray-100 hover:bg-gray-50 hover:bg-opacity-50- flex p-6 border-b border-blue-gray-200 dark:border-gray-800"
    end
  end

  def icon_for(kind) do
    assigns = %{}

    case kind do
      :widgets ->
        ~H"""
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
        </svg>
        """

      :edit ->
        ~H"""
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
        </svg>
        """

      :tickets ->
        ~H"""
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
        </svg>
        """

      :attendees ->
        ~H"""
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
        </svg>
        """

      :schedule ->
        ~H"""
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        """

      :tax ->
        ~H"""
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l3.5-2 3.5 2 3.5-2 3.5 2zM10 8.5a.5.5 0 11-1 0 .5.5 0 011 0zm5 5a.5.5 0 11-1 0 .5.5 0 011 0z" />
        </svg>
        """

      :email_attendees ->
        ~H"""
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        """

      :security ->
        ~H"""
          <svg class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400" x-description="Heroicon name: outline/key" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path>
          </svg>
        """

      :sponsors ->
        ~H"""
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z" />
          </svg>
        """

      _ ->
        ""
    end
  end

  def render(assigns) do
    ~H"""
    <nav aria-label="Sections" class="hidden flex-shrink-0 w-96 border-r-gray-500 border-blue-gray-600 xl:flex xl:flex-col">
      <div class="flex-shrink-0 h-16 px-6 border-b border-blue-gray-600 flex items-center">
        <p class="text-lg font-medium text-blue-gray-900">Settings</p>
      </div>

      <div class="flex-1 min-h-0 overflow-y-auto bg-gray-900">
        <%= for item <- menu_items(@event) do %>
          <%= live_redirect to: item.to, class: item_class(@live_action, item.namespace) do %>
            <%= icon_for(item.namespace) %>
            <div class="ml-3 text-sm">
              <p class="font-medium text-blue-gray-900"><%= item.title %> </p>
              <p class="mt-1 text-blue-gray-500"><%= item.sub %></p>
            </div>
          <% end %>
        <% end %>
      </div>
    </nav>
    """
  end
end
