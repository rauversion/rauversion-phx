defmodule RauversionWeb.ProfileLive.MenuComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{data: _data} = assigns) do
    ~H"""
    <div class="relative dark:bg-black">
    <div class="absolute inset-0 shadow z-30 pointer-events-none" aria-hidden="true"></div>
    <div class="z-20 sticky top-0">
      <div class="max-w-7xl mx-auto flex justify-between items-center px-4 py-5 sm:px-6 sm:py-4 lg:px-8 md:justify-start md:space-x-10">

        <div class="hidden md:flex-1 md:flex md:items-center md:justify-between">
          <nav class="flex space-x-10">
            <%= for %{name: name, url: url, selected: selected, kind: _kind} <- assigns.data do %>
              <% #= selected %>
              <% #= kind %>
              <%= live_redirect name,
                id: "profile-menu-#{name}",
                "data-cy": "profile-menu-#{name}",
                to: url,
                class: "text-base font-medium #{if selected do "border-b border-b-4 text-gray-800 hover:text-gray-900 border-brand-500 dark:text-gray-200 dark:hover:text-gray-100 dark:border-brand-300 " else "text-gray-500 hover:text-gray-900 dark:text-gray-100 dark:hover:text-gray-100" end}" %>
            <% end %>
          </nav>

          <%= if @current_user && @current_user.id != @profile.id do %>
            <div class="flex items-center md:ml-12">

              <%= if @user_follow do %>
                <%= link to: "#", phx_click: "unfollow-user", class: "inline-flex items-center px-4 py-2 border border-brand-300 shadow-sm text-base font-medium rounded-md text-brand-700 bg-white hover:bg-brand-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewbox="0 0 20 20" fill="currentColor">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                  <span class="mx-2"><%= gettext "Following" %></span>
                <% end %>
              <% else %>
                <%= link to: "#", phx_click: "follow-user", class: "inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" do %>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" view-box="0 0 20 20" fill="currentColor">
                    <path d="M8 9a3 3 0 100-6 3 3 0 000 6zM8 11a6 6 0 016 6H2a6 6 0 016-6zM16 7a1 1 0 10-2 0v1h-1a1 1 0 100 2h1v1a1 1 0 102 0v-1h1a1 1 0 100-2h-1V7z" />
                  </svg>
                  <span class="mx-2"><%= gettext "Follow" %></span>
                <% end %>
              <% end %>
            </div>
          <% end %>

          <%= if @current_user && @current_user.id == @profile.id do %>
            <div class="flex items-center md:ml-12">
              <%= live_redirect gettext( "Your insights"), to: Routes.profile_index_path(@socket, :insights, @username), class: "text-base font-medium text-gray-500 hover:text-gray-900  dark:text-gray-300 dark:hover:text-gray-100" %>
              <%= live_redirect gettext("Edit profile"), to: "/users/settings", class: "ml-8 inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-gray-600 hover:bg-gray-700" %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    </div>
    """
  end
end
