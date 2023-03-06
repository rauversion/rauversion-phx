defmodule RauversionWeb.TrackLive.Components.Supporters do
  use RauversionWeb, :live_component

  def render(assigns = %{kind: "albums", supporters: _supporters}) do
    ~H"""
    <div class="sm:text-xl text-sm container mx-auto my-4 flex flex-col space-y-4">

      <h3 class="font-bold font-medium" :if={Enum.any?(@supporters)}>
        <%= gettext("Supporters") %>
      </h3>

      <div class="-space-x-4">
        <%= for supporter <- @supporters do %>
          <%= live_redirect to: Routes.profile_index_path(@socket, :index, supporter.album_order.purchase_order.user.username) do %>
            <%= img_tag(
              Rauversion.Accounts.avatar_url(supporter.album_order.purchase_order.user, :medium),
              class: "relative z-30 inline object-cover w-10 h-10 border-2 border-white rounded-full"
            ) %>
            <h3 class="hidden mt-6 text-gray-900 dark:text-gray-100 text-sm font-medium">
              <%= supporter.album_order.purchase_order.user.username %>
            </h3>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  def render(assigns = %{kind: "tracks", supporters: _supporters}) do
    ~H"""
    <div class="sm:text-xl text-sm container mx-auto my-4 flex flex-col space-y-4">
      <h3 class="font-bold font-medium" :if={Enum.any?(@supporters)}>
        <%= gettext("Supporters") %>
      </h3>
      <div class="-space-x-4">
        <%= for supporter <- @supporters do %>
          <%= live_redirect to: Routes.profile_index_path(@socket, :index, supporter.track_order.purchase_order.user.username) do %>
            <%= img_tag(
              Rauversion.Accounts.avatar_url(supporter.track_order.purchase_order.user, :medium),
              class: "relative z-30 inline object-cover w-10 h-10 border-2 border-white rounded-full"
            ) %>
            <h3 class="hidden mt-6 text-gray-900 dark:text-gray-100 text-sm font-medium">
              <%= supporter.track_order.purchase_order.user.username %>
            </h3>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end
end
