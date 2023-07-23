defmodule RauversionWeb.ProfileLive.StatsComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{track: _track, profile: _profile} = assigns) do
    ~H"""
    <div class="grid grid-cols-3 divide-x dark:divide-gray-700">
      <div class="p-4">
        <p class="text-base font-medium text-gray-900 dark:text-gray-100">
          <%= gettext("Following") %>
        </p>
        <span class="text-base font-normal text-gray-500 dark:text-gray-200 text-xl ">
          <.link
            navigate={Routes.follows_index_path(@socket, :followings, @profile.username)}
          ><%= Rauversion.UserFollows.followings_for(@profile) %>
          </.link>
        </span>
      </div>
      <div class="p-4">
        <p class="text-base font-medium text-gray-900 dark:text-gray-100">
          <%= gettext("Followers") %>
        </p>
        <span class="text-base font-normal text-gray-500 dark:text-gray-200 text-xl ">
          <.link
            navigate={Routes.follows_index_path(@socket, :followers, @profile.username)}
          ><%= Rauversion.UserFollows.followers_for(@profile) %>
          </.link>
        </span>
      </div>
      <div class="p-4">
        <p class="text-base font-medium text-gray-900 dark:text-gray-100"><%= gettext("Tracks") %></p>
        <span class="text-base font-normal text-gray-500 dark:text-gray-200 text-xl ">
          <%= Rauversion.Accounts.tracks_count(@profile) %>
        </span>
      </div>
    </div>
    """
  end
end
