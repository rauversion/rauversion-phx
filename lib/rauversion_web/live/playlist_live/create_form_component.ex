defmodule RauversionWeb.PlaylistLive.CreateFormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""

    <div class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800 sm:space-y-5">
      <div class="mx-2 py-6">
        <div class="relative">

          <nav class="flex space-x-4" aria-label="Tabs" data-controller="tabs">
            <a href="#" phx-click={"add-to-tab"} phx-target={@ref} class={"#{if @tab === "add-to-tab" do "bg-brand-100 text-brand-700" else "text-brand-500 hover:text-brand-700" end } px-3 py-2 font-medium text-sm rounded-md"}> Add to playlist </a>
            <a href="#" phx-click={"create-playlist-tab"} phx-target={@ref} class={"#{if @tab === "create-playlist-tab" do "bg-brand-100 text-brand-700" else "text-brand-500 hover:text-brand-700" end } px-3 py-2 font-medium text-sm rounded-md"}> Create a playlist </a>
          </nav>

          <section id="add-to-tab" class={"tab-pane py-4 #{if @tab === "add-to-tab" do "block" else "hidden" end }"}>

            <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
            <%= gettext "Add to playlist" %>
            </h2>

            <div class="sm:col-span-6">
              <div class="flow-root mt-6">
                <ul role="list" class="-my-5 divide-y divide-gray-200 dark:divide-gray-800">
                  <%= for item <- @playlists do %>
                    <li class="py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0">
                        <% # IO.inspect(item) %>
                          <%
                            #= img_tag(Rauversion.Tracks.proxy_cover_representation_url(item.track),
                            #class: "h-8 w-8 rounded-full")
                          %>
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate"><%= item.title %></p>
                          <p class="text-sm text-gray-500 truncate"></p>
                        </div>
                        <div>

                          <%= if length(item.track_playlists) > 0 do %>
                            <a href="#"
                              phx-click="remove-from-playlist"
                              phx-target={@ref}
                              phx-value-playlist={item.id}
                              phx-value-track-playlist={List.first(item.track_playlists).id}
                              class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                              <%= gettext "Remove" %>
                            </a>
                          <% else %>
                            <a href="#"
                              phx-click="add-to-playlist"
                              phx-target={@ref}
                              phx-value-playlist={item.id}
                              class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                              <%= gettext "Add" %>
                            </a>
                          <% end %>
                        </div>
                      </div>
                    </li>
                  <% end %>
                </ul>
              </div>
              <div class="mt-6 hidden">
                <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                <%= gettext "View all" %>
                </a>
              </div>
            </div>

          </section>

          <section id="create-playlist-tab" class={"tab-pane py-4 #{if @tab === "create-playlist-tab" do "block" else "hidden" end }"}>

            <%= if @playlist.id == nil do %>
              <.form
                let={f}
                for={@changeset}
                id="playlist-form"
                phx-target={@ref}
                phx-change="validate"
                phx-submit="save">

                <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
                <%= gettext "Create playlist" %>
                </h2>

                <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

                  <div class="sm:col-span-6">

                    <label for="title" class="block text-sm font-medium text-gray-700">
                    <%= gettext "Playlist title" %>
                    </label>
                    <div class="mt-1">
                      <%= form_input_renderer(f, %{type: :text_input, name: :title, wrapper_class: ""}) %>
                      <% #= text_input f, :title, autocomplete: "given-name", class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                      <% #= error_tag f, :title %>
                    </div>
                  </div>

                  <div class="flex items-center space-x-2">

                    <div class="flex items-center">
                      <label for="push-everything" class="block text-md font-bold text-gray-700 dark:text-gray-300">
                      <%= gettext "Privacy" %>
                      </label>
                    </div>

                    <div class="flex items-center">
                      <%= radio_button f, :private, true, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300" %>
                      <label for="push-everything" class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300">
                      <%= gettext "Private" %>
                      </label>
                    </div>

                    <div class="flex items-center">
                      <%= radio_button f, :private, false, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300" %>
                      <label for="push-email" class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300">
                      <%= gettext "Public" %>
                      </label>
                    </div>
                  </div>

                  <div class="sm:col-span-6 flex justify-end">
                    <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
                  </div>

                  <div class="sm:col-span-6">
                    <div class="flow-root mt-6">
                      <ul role="list" class="-my-5 divide-y divide-gray-200 dark:divide-gray-800">
                        <%= inputs_for f, :track_playlists, fn track -> %>

                          <%= hidden_input track, :track_id %>

                          <li class="py-4">
                            <div class="flex items-center space-x-4">
                              <div class="flex-shrink-0">
                                <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                              </div>
                              <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">
                                  <%= @new_track.title %>
                                </p>
                                <p class="text-sm text-gray-500 truncate"><%= @new_track.user.username %></p>
                              </div>
                              <div>
                                <a href="#" phx-click="remove-track" target={@ref} class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                                <%= gettext "remove" %>
                                </a>
                              </div>
                            </div>
                          </li>
                        <% end %>
                      </ul>
                    </div>
                    <div class="mt-6 hidden">
                      <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"> View all </a>
                    </div>
                  </div>
                </div>

              </.form>

            <% else %>
              <h3 class="text-2xl p-4"><%= @playlist.title %></h3>
              <div class="p-4 border border-gray-800">
                <%= live_redirect "Go to playlist", to: Routes.playlist_show_path(@socket, :show, @playlist.slug) %>
              </div>
            <% end %>

          </section>

        </div>
      </div>
    </div>

    """
  end
end
