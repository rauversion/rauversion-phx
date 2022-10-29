defmodule RauversionWeb.ProfileLive.HeadingComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{profile: _profile} = assigns) do
    ~H"""
      <div class="sm:h-64 h-24 bg-black sticky top-0 z-40 sm:relative">
        <div class="flex justify-between bg-cover bg-center" style={"background: url('#{Rauversion.BlobUtils.variant_url(@profile, :profile_header, %{resize_to_fill: "2480x520"} )}')"}>
          <div class="flex">
            <div class="m-4">
              <%= img_tag(
                Rauversion.BlobUtils.variant_url(@profile, :profile_header, %{resize_to_fill: "200x200"} ),
              class: "sm:w-48 sm:h-48 w-16 h-16 rounded-full") %>
            </div>
            <div class="text-white sm:mt-6 space-y-1 sm:space-y-2 flex flex-col justify-start items-start">
              <p class="sm:text-3xl text-lg font-extrabold bg-black p-1 inline-block">
                <%= @profile.username %>
              </p>
              <%= if @profile.first_name || @profile.last_name do %>
                <p class="sm:text-lg text-xs font-light bg-black p-1 inline-block">
                  <%= @profile.first_name %>
                  <%= @profile.last_name %>
                </p>
              <% end %>
              <%= if @profile.city || @profile.country do %>
                <p class="sm:text-lg text-xs font-light bg-black p-1 inline-block">
                  <%= @profile.city %>
                  <%= @profile.country %>
                </p>
              <% end %>
            </div>
          </div>
          <div class="hidden">bjkkjk</div>
        </div>
      </div>
    """
  end
end
