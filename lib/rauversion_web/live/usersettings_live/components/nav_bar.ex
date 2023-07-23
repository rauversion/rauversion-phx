defmodule RauversionWeb.UserSettingsLive.NavBar do
  # use Phoenix.Component
  use RauversionWeb, :live_component

  def menu_items do
    [
      %{
        to: "/users/settings",
        namespace: :profile,
        title: gettext("Account"),
        sub: gettext("Basic Account Information.")
      },
      %{
        to: "/users/settings/email",
        namespace: :email,
        title: gettext("Change Email"),
        sub: gettext("Change Email information.")
      },
      %{
        to: "/users/settings/security",
        namespace: :security,
        title: gettext("Security"),
        sub: gettext("Change your credentials")
      },
      %{
        to: "/users/settings/notifications",
        namespace: :notifications,
        title: gettext("Notifications"),
        sub: gettext("Change your notification preferences.")
      },
      %{
        to: "/users/settings/integrations",
        namespace: :integrations,
        title: gettext("Integrations"),
        sub: gettext("Manage your external integrations.")
      },
      %{
        to: "/users/settings/transbank",
        namespace: :transbank,
        title: gettext("Transbank settings"),
        sub: gettext("Manage your transbank commerce (Chile only).")
      },
      %{
        to: "/users/settings/invitations",
        namespace: :invitations,
        title: gettext("Invitations"),
        sub: gettext("Invite other artists to your account.")
      }
    ]
  end

  def item_class(action, kind) do
    if action == kind do
      "dark:bg-black dark:text-gray-100 bg-gray-50 bg-opacity-50 flex p-6 border-b border-gray-gray-200 dark:border-gray-800"
    else
      "dark:bg-gray-900 dark:text-gray-100 hover:bg-gray-50 hover:bg-opacity-50 flex p-6 border-b border-blue-gray-200 dark:border-gray-800"
    end
  end

  def icon_for(kind) do
    assigns = %{}

    case kind do
      :transbank ->
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
            d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 013 6h-.75m0 0v-.375c0-.621.504-1.125 1.125-1.125H20.25M2.25 6v9m18-10.5v.75c0 .414.336.75.75.75h.75m-1.5-1.5h.375c.621 0 1.125.504 1.125 1.125v9.75c0 .621-.504 1.125-1.125 1.125h-.375m1.5-1.5H21a.75.75 0 00-.75.75v.75m0 0H3.75m0 0h-.375a1.125 1.125 0 01-1.125-1.125V15m1.5 1.5v-.75A.75.75 0 003 15h-.75M15 10.5a3 3 0 11-6 0 3 3 0 016 0zm3 0h.008v.008H18V10.5zm-12 0h.008v.008H6V10.5z"
          />
        </svg>
        """

      :invitations ->
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
            d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5"
          />
        </svg>
        """

      :profile ->
        ~H"""
        <svg
          class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400"
          x-description="Heroicon name: outline/cog"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
          >
          </path>
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
          >
          </path>
        </svg>
        """

      :email ->
        ~H"""
        <svg
          class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400"
          x-description="Heroicon name: outline/mail"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
          />
        </svg>
        """

      :security ->
        ~H"""
        <svg
          class="flex-shrink-0 -mt-0.5 h-6 w-6 text-blue-gray-400"
          x-description="Heroicon name: outline/key"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"
          >
          </path>
        </svg>
        """

      :integrations ->
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
            d="M13.5 16.875h3.375m0 0h3.375m-3.375 0V13.5m0 3.375v3.375M6 10.5h2.25a2.25 2.25 0 002.25-2.25V6a2.25 2.25 0 00-2.25-2.25H6A2.25 2.25 0 003.75 6v2.25A2.25 2.25 0 006 10.5zm0 9.75h2.25A2.25 2.25 0 0010.5 18v-2.25a2.25 2.25 0 00-2.25-2.25H6a2.25 2.25 0 00-2.25 2.25V18A2.25 2.25 0 006 20.25zm9.75-9.75H18a2.25 2.25 0 002.25-2.25V6A2.25 2.25 0 0018 3.75h-2.25A2.25 2.25 0 0013.5 6v2.25a2.25 2.25 0 002.25 2.25z"
          />
        </svg>
        """

      :notifications ->
        ~H"""
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-6 w-6"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          stroke-width="2"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
          />
        </svg>
        """

      _ ->
        nil
    end
  end

  def render(assigns) do
    ~H"""
    <nav
      aria-label="Sections"
      class="hidden- w-20 flex-shrink-0 xl:w-96 border-r-gray-500 border-blue-gray-600 xl:flex xl:flex-col"
    >
      <div class="hidden xl:flex flex-shrink-0 h-16 px-6 border-b- border-gray-200 dark:border-gray-800 flex items-center">
        <p class="text-lg font-medium text-gray-900 dark:text-gray-100">Settings</p>
      </div>

      <div class="flex-1 min-h-0 overflow-y-auto">
        <%= for item <- menu_items() do %>
          <.link navigate={item.to}
            class={item_class(@live_action, item.namespace)}>
            <%= icon_for(item.namespace) %>
            <div class="ml-3 text-sm hidden xl:block">
              <p class="font-medium text-gray-900 dark:text-gray-100"><%= item.title %></p>
              <p class="mt-1 text-gray-500 dark:text-gray-300"><%= item.sub %></p>
            </div>
          </.link>
        <% end %>
      </div>
    </nav>
    """
  end
end
