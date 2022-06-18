defmodule RauversionWeb.ProfileLive.HeadingComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{profile: profile} = assigns) do
    ~H"""
      <div class="h-64 bg-black">
        <div class="flex justify-between">
          <div class="flex">
            <div class="m-4">

              <%= img_tag(Rauversion.Accounts.avatar_url(@profile),
              class: "w-48 h-48 rounded-full") %>
            </div>
            <div class="text-white mt-6">
              <p class="text-2xl sm:text-3xl font-extrabold">
                <%= @profile.username %>
              </p>
              <p class="text-xl sm:text-2xl font-extrabold">
                Santiago, Chile
              </p>
            </div>
          </div>
          <div class="">bjkkjk</div>
        </div>
      </div>
    """
  end
end
