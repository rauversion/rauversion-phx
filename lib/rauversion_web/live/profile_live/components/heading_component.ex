defmodule RauversionWeb.ProfileLive.HeadingComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{profile: profile} = assigns) do
    ~H"""
      <div class="sm:h-64 h-24 bg-black sticky top-0 z-50 sm:relative">
        <div class="flex justify-between">
          <div class="flex">
            <div class="m-4">

              <%= img_tag(Rauversion.Accounts.avatar_url(@profile),
              class: "sm:w-48 sm:h-48 w-16 h-16 rounded-full") %>
            </div>
            <div class="text-white mt-6">
              <p class="sm:text-3xl text-lg font-extrabold">
                <%= @profile.username %>
              </p>
              <p class="text-sm sm:text-xl font-extrabold">
                Santiago, Chile
              </p>
            </div>
          </div>
          <div class="hidden">bjkkjk</div>
        </div>
      </div>
    """
  end
end
