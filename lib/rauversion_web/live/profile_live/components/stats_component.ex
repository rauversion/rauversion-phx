defmodule RauversionWeb.ProfileLive.StatsComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{track: track, profile: profile} = assigns) do
    ~H"""
    <div class="grid grid-cols-3 divide-x">
      <div class="p-4">
        <p class="text-base font-medium text-gray-900">Following</p>
        <span class="text-base font-light text-gray-500">
          <%= live_redirect Rauversion.UserFollows.followings_for(profile), to: Routes.follows_index_path(@socket, :followings, profile.username)  %>
        </span>
      </div>
      <div  class="p-4">
        <p class="text-base font-medium text-gray-900">Followers</p>
        <span class="text-base font-light text-gray-500">
          <%= live_redirect Rauversion.UserFollows.followers_for(profile), to: Routes.follows_index_path(@socket, :followers, profile.username)  %>
        </span>
      </div>
      <div  class="p-4">
        <p class="text-base font-medium text-gray-900">Tracks</p>
        <span class="text-base font-light text-gray-500">
          <%= Rauversion.Accounts.tracks_count(profile) %>
        </span>
      </div>
    </div>
    """
  end
end
