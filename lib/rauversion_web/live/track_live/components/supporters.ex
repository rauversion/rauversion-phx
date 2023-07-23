defmodule RauversionWeb.TrackLive.Components.Supporters do
  use RauversionWeb, :live_component

  def render(assigns = %{kind: "albums", supporters: supporters}) do
    ~H"""
    <div class="sm:text-xl text-sm container mx-auto my-4 flex flex-col space-y-4">
      <%= if Enum.any?(@supporters) do %>
        <h3 class="font-bold font-medium"><%= gettext("Supporters") %></h3>
      <% end %>

      <div class="-space-x-4">
        <%= for supporter <- @supporters do %>
          <.link navigate={Routes.profile_index_path(@socket, :index, supporter.album_order.purchase_order.user.username)}>
            <%= img_tag(
              Rauversion.Accounts.avatar_url(supporter.album_order.purchase_order.user, :medium),
              class: "relative z-30 inline object-cover w-10 h-10 border-2 border-white rounded-full"
            ) %>
            <h3 class="hidden mt-6 text-gray-900 dark:text-gray-100 text-sm font-medium">
              <%= supporter.album_order.purchase_order.user.username %>
            </h3>
          </.link>
        <% end %>
      </div>
    </div>
    """
  end

  def render(assigns = %{kind: "tracks", supporters: supporters}) do
    ~H"""
    <div class="sm:text-xl text-sm container mx-auto my-4 flex flex-col space-y-4">
      <%= if Enum.any?(@supporters) do %>
        <h3 class="font-bold font-medium"><%= gettext("Supporters") %></h3>
      <% end %>
      <div class="-space-x-4">
        <%= for supporter <- @supporters do %>
          <.link navigate={Routes.profile_index_path(@socket, :index, supporter.track_order.purchase_order.user.username)}>
            <%= img_tag(
              Rauversion.Accounts.avatar_url(supporter.track_order.purchase_order.user, :medium),
              class: "relative z-30 inline object-cover w-10 h-10 border-2 border-white rounded-full"
            ) %>
            <h3 class="hidden mt-6 text-gray-900 dark:text-gray-100 text-sm font-medium">
              <%= supporter.track_order.purchase_order.user.username %>
            </h3>
          </.link>
        <% end %>
      </div>
    </div>
    """
  end
end
