defmodule RauversionWeb.PlaylistLive.PlaylistComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def update(assigns = %{current_user: _user = nil}, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:like, nil)
    }
  end

  def update(assigns, socket) do
    case assigns do
      %{current_user: _current_user = %Rauversion.Accounts.User{}} ->
        like =
          case assigns.playlist.likes do
            [like] -> like
            _ -> nil
          end

        {
          :ok,
          socket
          |> assign(assigns)
          |> assign(:like, like)
        }

      _ ->
        {:ok, socket |> assign(:like, nil)}
    end
  end

  def handle_event(
        "like-playlist",
        %{"id" => _id},
        socket = %{
          assigns: %{playlist: playlist, current_user: current_user = %Rauversion.Accounts.User{}}
        }
      ) do
    attrs = %{user_id: current_user.id, playlist_id: playlist.id}

    case socket.assigns.like do
      %Rauversion.PlaylistLikes.PlaylistLike{} = playlist_like ->
        Rauversion.PlaylistLikes.delete_playlist_like(playlist_like)
        {:noreply, assign(socket, :like, nil)}

      _ ->
        {:ok, %Rauversion.PlaylistLikes.PlaylistLike{} = playlist_like} =
          Rauversion.PlaylistLikes.create_playlist_like(attrs)

        {:noreply, assign(socket, :like, playlist_like)}
    end
  end

  def handle_event(
        "like-playlist",
        %{"id" => _id},
        socket = %{assigns: %{playlist: _playlist, current_user: _user = nil}}
      ) do
    # TODO: SHOW MODAL HERE
    {:noreply, socket}
  end

  def render(
        %{
          current_user: _current_user,
          like: like
        } = assigns
      ) do
    assigns = assign(assigns, :like_class, active_button_class(like))

    ~H"""
      <div class="my-2 p-2 border-- rounded-md shadow-xs mx-3 dark:bg-gray-900" id={"playlist-item-#{@playlist.id}"}>
        <div class="flex space-x-3">
          <div class="w-32 h-32 bg-red-600"></div>
          <div class="flex-grow">
            <div class="flex flex-col">
              <div class="space-y-2">
                <h3 class="flex items-center space-x-2 mt-3- text-xl font-extrabold tracking-tight text-slate-900 dark:text-gray-100">
                  <%= live_redirect @playlist.title,
                    to: Routes.playlist_show_path(@socket, :show, @playlist)
                  %>
                  <%= if Rauversion.Playlists.is_album?(@playlist) do %>
                      <span class="text-xs dark:text-gray-400 font-thin">
                        Album <%= simple_date_for(@playlist.release_date, :short) %>
                      </span>
                    <% end %>
                </h3>
                <ul role="list" class="-my-5 divide-y divide-gray-200 dark:divide-gray-800">
                  <%= for track_playlists <- @playlist.track_playlists do %>
                    <li class="py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0">
                        <%= img_tag(Rauversion.Tracks.variant_url(
                          track_playlists.track, "cover", %{resize_to_limit: "360x360"}),
                          class: "h-8 w-8 rounded-full")
                        %>

                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate"><%= track_playlists.track.title %></p>
                          <p class="text-sm text-gray-500 dark:text-gray-300 truncate"><%= @playlist.user.username  %></p>
                        </div>
                        <!--
                        <div>
                          <a href="#" phx-click="remove-track"
                            target-nono={@myself}
                            class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                            remove
                          </a>
                        </div>
                        -->
                      </div>
                    </li>
                  <% end %>
                </ul>
              </div>

              <div class="p-2 sm:p-0 sm:pt-2 flex items-center space-x-1" data-turbo="false">
                <% #= live_redirect "Show", to: Routes.track_show_path(@socket, :show, track), class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>

                <.live_component
                  id={"share-playlist-button-#{@playlist.id}"}
                  module={RauversionWeb.PlaylistLive.SharePlaylistButtonComponent}
                  playlist={@playlist}
                />

                <%= link to: "#", phx_click: "like-playlist", phx_target: @myself, phx_value_id: @playlist.id,
                  class: @like_class.class do %>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                    </svg>
                    <span><%= @playlist.likes_count %> Like</span>
                <% end %>

                <%= if @current_user && @current_user.id == @playlist.user_id do %>
                  <%= live_patch to: Routes.playlist_show_path(@socket, :edit, @playlist), class: "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-700 shadow-sm text-xs font-medium rounded text-gray-700 bg-white dark:text-gray-300 dark:bg-black  hover:bg-gray-50 dark:hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                      <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                    </svg>
                    <span><%= gettext "Edit" %></span>
                  <% end %>
                  <%= link to: "#",
                    phx_click: "delete",
                    phx_value_id: @playlist.id,
                    phx_target: @list_ref,
                    data: [confirm: "Are you sure?"], class: "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-700 shadow-sm text-xs font-medium rounded text-gray-700 bg-white dark:text-gray-300 dark:bg-black  hover:bg-gray-50 dark:hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
                    </svg>
                    <span><%= gettext "Delete" %></span>
                  <% end %>
                <% end %>
              </div>

            </div>
          </div>
        </div>
      </div>
    """
  end
end
