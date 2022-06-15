defmodule RauversionWeb.ProfileLive.StatsComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{track: track} = assigns) do
    ~H"""
    <div class="grid grid-cols-3 divide-x">
      <div class="p-4">
        <p class="text-base font-medium text-gray-900">Following</p>
        <span class="text-base font-light text-gray-500">
          xxx
        </span>
      </div>
      <div  class="p-4">
        <p class="text-base font-medium text-gray-900">Followers</p>
        <span class="text-base font-light text-gray-500">
          <% #= @profile.followers(User).size %>
        </span>
      </div>
      <div  class="p-4">
        <p class="text-base font-medium text-gray-900">Tracks</p>
        <span class="text-base font-light text-gray-500">
          <% #= @profile.tracks.size %>
        </span>
      </div>
    </div>
    """
  end
end
