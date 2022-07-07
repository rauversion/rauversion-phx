defmodule RauversionWeb.PlaylistLive.EditFormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""

    <div class="space-y-8 divide-y divide-gray-200 sm:space-y-5">
      <.form
      let={f}
      for={@changeset}
      id="playlist-form"
      phx-target={@ref}
      phx-change="validate"
      phx-submit="save">

      <%= label f, :description %>
      <%= textarea f, :description %>
      <%= error_tag f, :description %>

      <%= label f, :title %>
      <%= text_input f, :title %>
      <%= error_tag f, :title %>


      <ul role="list" class="-my-5 divide-y divide-gray-200">
        <%= inputs_for f, :track_playlists, fn track -> %>

          <%= hidden_input track, :track_id %>

          <li class="py-4">
            <div class="flex items-center space-x-4">
              <div class="flex-shrink-0">
                <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-gray-900 truncate"><%= track.id %></p>
                <p class="text-sm text-gray-500 truncate">@leonardkrasner</p>
              </div>
              <div>
                <a href="#" phx-click="remove-track" target={@ref} class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                  remove
                </a>
              </div>
            </div>
          </li>
        <% end %>
      </ul>

      <div>
        <%= submit "Save", phx_disable_with: "Saving..." %>
      </div>
    </.form>
    </div>

    """
  end
end
