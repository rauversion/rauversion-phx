defmodule RauversionWeb.TrackLive.TrackComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.Tracks

  @impl true
  def update(assigns = %{current_user: nil}, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:repost, nil)
    }
  end

  @impl true
  def update(assigns = %{current_user: _current_user}, socket) do
    case assigns do
      %{current_user: current_user} ->
        repost =
          case assigns.track.reposts do
            [repost] -> repost
            _ -> nil
          end

        like =
          case assigns.track.likes do
            [like] -> like
            _ -> nil
          end

        {
          :ok,
          socket
          |> assign(assigns)
          |> assign(:repost, repost)
          |> assign(:like, like)
        }

      _ ->
        {:ok, socket |> assign(:repost, nil)}
    end
  end

  @impl true
  def handle_event(
        "like-track",
        %{"id" => id},
        socket = %{assigns: %{track: track, current_user: current_user}}
      ) do
    attrs = %{user_id: current_user.id, track_id: track.id}

    case socket.assigns.like do
      %Rauversion.TrackLikes.TrackLike{} = track_like ->
        Rauversion.TrackLikes.delete_track_like(track_like)
        {:noreply, assign(socket, :like, nil)}

      _ ->
        {:ok, %Rauversion.TrackLikes.TrackLike{} = track_like} =
          Rauversion.TrackLikes.create_track_like(attrs)

        {:noreply, assign(socket, :like, track_like)}
    end
  end

  @impl true
  def handle_event(
        "like-track",
        %{"id" => _id},
        socket = %{assigns: %{track: _track, current_user: nil}}
      ) do
    # TODO: SHOW MODAL HERE
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "repost-track",
        %{"id" => id},
        socket = %{
          assigns: %{track: track, current_user: current_user = %Rauversion.Accounts.User{}}
        }
      ) do
    attrs = %{user_id: current_user.id, track_id: track.id}

    case socket.assigns.repost do
      %Rauversion.Reposts.Repost{} = repost ->
        Rauversion.Reposts.delete_repost(repost)
        {:noreply, assign(socket, :repost, nil)}

      _ ->
        {:ok, %Rauversion.Reposts.Repost{} = repost} = Rauversion.Reposts.create_repost(attrs)
        {:noreply, assign(socket, :repost, repost)}
    end
  end

  @impl true
  def handle_event(
        "repost-track",
        %{"id" => _id},
        socket = %{assigns: %{track: _track, current_user: nil}}
      ) do
    # TODO: SHOW MODAL HERE
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-to-next", %{"id" => id}, socket) do
    track = Tracks.get_track!(id) |> Rauversion.Repo.preload([:user, :mp3_audio_blob])

    struct = %{
      id: track.id,
      title: track.title,
      username: track.user.username
    }

    {:noreply, push_event(socket, "add-to-next", %{value: struct})}
  end

  @impl true
  def render(
        %{
          track: track,
          current_user: current_user,
          repost: repost,
          like: like
        } = assigns
      ) do
    repost_class = active_button_class(repost)
    like_class = active_button_class(like)

    ~H"""
    <div id={"track-item-#{track.id}"} class="flex flex-col sm:flex-row border rounded-md shadow-sm my-2">
      <div class="w-full sm:w-1/4 mb-4 flex-shrink-0 sm:mb-0 sm:mr-4">

        <div class="group relative aspect-w-1 aspect-h-1 rounded-md bg-gray-100 overflow-hidden">
          <% #= image_tag url_for(track.cover.variant(resize_to_fit: [300, 300])), class: "object-center object-cover group-hover:opacity-75" %>

          <%= img_tag(Rauversion.Tracks.blob_url(track, "cover"), class: "object-center object-cover group-hover:opacity-75") %>

          <div class="flex flex-col justify-end">
            <!--<div class="p-4 bg-white bg-opacity-60 text-sm">
              <a href="#" class="font-medium text-gray-900">
                <span class="absolute inset-0" aria-hidden="true"></span>

              </a>
              <p aria-hidden="true" class="mt-0.5 text-gray-700 sm:mt-1">Listen now</p>
            </div>-->
          </div>
        </div>

      </div>

      <div class="w-full">

        <% # if track.audio.persisted? %>
          <%= content_tag :div, id: "track-player-#{track.id}",
                                "phx-hook": "TrackHook",
                                "phx-update": "ignore",
                                "data-controllersss": "audio",
                                "data-audio-id": track.id,
                                "data-audio-target": "player",
                                "data-audio-height-value": 70,
                                "data-audio-peaks": Jason.encode!(Rauversion.Tracks.metadata(track, :peaks)),
                                "data-audio-url": Rauversion.Tracks.blob_proxy_url(track, "mp3_audio"),
                                class: "h-32"  do %>
            <div class='controls flex items-center'>
              <span class="relative z-0 inline-flex py-2 px-2 sm:px-0">
                <button type="button"
                  data-action='audio#play'
                  data-audio-target="play"
                  class="relative inline-flex items-center px-2 py-2 rounded-full border border-orange-300 bg-orange-600 text-sm font-medium text-white hover:bg-orange-500 focus:z-10 focus:outline-none focus:ring-1 focus:ring-orange-700 focus:border-orange-400">
                  <span class="sr-only">Play</span>
                  <svg data-audio-target="playicon" style="display:none" viewBox="0 0 15 15" class="h-6 w-6"  fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M5.5 3v9m4-9v9" stroke="currentColor"></path></svg>
                  <svg data-audio-target="pauseicon"  viewBox="0 0 15 15" class="h-6 w-6" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M4.5 12.5v-10l7 5-7 5z" stroke="currentColor" stroke-linejoin="round"></path></svg>
                </button>

                <button type="button"
                data-action='audio#pause'
                data-audio-target="pause"
                class="hidden -ml-px relative inline-flex items-center px-2 py-2 rounded-full border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-10 focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500">
                  <span class="sr-only">Next</span>
                  <svg viewBox="0 0 15 15" class="h-6 w-6" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M11.5 3.5h-8v8h8v-8z" stroke="currentColor"></path></svg>
                </button>

              </span>
              <div class="flex-grow  ml-2 flex items-center justify-between">

                <div class="">
                  <h4 class="text-md font-bold">
                    <%= live_redirect track.title, to: Routes.track_show_path(@socket, :show, track) %>
                  </h4>
                  <h5 class="text-sm font-">
                    <%= case track.user do
                      %Rauversion.Accounts.User{} ->  track.user.username
                      _ -> ""
                    end %>
                  </h5>
                </div>

                <%= if track.private do %>
                  <div class="mr-2">
                    <div class="bg-orange-500 text-white text-xs p-1 rounded-md inline-flex space-x-1 items-center">
                      <svg viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M5.5 7h4V6h-4v1zm4.5.5v3h1v-3h-1zM9.5 11h-4v1h4v-1zM5 10.5v-3H4v3h1zm.5.5a.5.5 0 01-.5-.5H4A1.5 1.5 0 005.5 12v-1zm4.5-.5a.5.5 0 01-.5.5v1a1.5 1.5 0 001.5-1.5h-1zM9.5 7a.5.5 0 01.5.5h1A1.5 1.5 0 009.5 6v1zm-4-1A1.5 1.5 0 004 7.5h1a.5.5 0 01.5-.5V6zm.5.5v-1H5v1h1zm3-1v1h1v-1H9zM7.5 4A1.5 1.5 0 019 5.5h1A2.5 2.5 0 007.5 3v1zM6 5.5A1.5 1.5 0 017.5 4V3A2.5 2.5 0 005 5.5h1z" fill="currentColor"></path></svg>
                      <span>private</span>
                    </div>
                  </div>
                <% end %>

              </div>
            </div>
          <% end %>
        <% #end %>

        <p class="hidden mt-1 text-sm text-gray-500">
          <%= track.description %>
        </p>

        <div class="p-2 sm:p-0 sm:pt-2 flex items-center space-x-1" data-turbo="false">
          <% #= live_redirect "Show", to: Routes.track_show_path(@socket, :show, track), class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>

          <.live_component
            id={"share-track-button-#{track.id}"}
            module={RauversionWeb.TrackLive.ShareTrackButtonComponent}
            track={track}
          />

          <%= link to: "#", phx_click: "repost-track", phx_target: @myself, phx_value_id: track.id,
            class: repost_class.class do %>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />
            </svg>
            <span>Repost</span>
          <% end %>

          <%= link to: "#", phx_click: "like-track", phx_target: @myself, phx_value_id: track.id,
            class: like_class.class do %>
            <%= if @like do %>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
              </svg>
            <% else %>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
              </svg>
            <% end %>
            <span>Like</span>
          <% end %>

          <%= if current_user do %>

            <.live_component
              id={"playlist-button-add-track-#{track.id}"}
              module={RauversionWeb.PlaylistLive.AddToPlaylistComponent}
              track={track}
              current_user={@current_user}
              return_to={Routes.playlist_index_path(@socket, :index)}
            />
          <% end %>

          <%= if current_user && current_user.id == track.user_id do %>
            <%= live_patch to:  Routes.track_show_path(@socket, :edit, track), class: "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
              </svg>
              <span>Edit</span>
            <% end %>
            <%= if @socket.assigns |> Map.get(:ref) do %>
              <%= link to: "#", phx_click: "delete-track", phx_target: @ref, phx_value_id: track.id, data: [confirm: "Are you sure?"], class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
                </svg>
                <span>Delete</span>
              <% end %>
            <% end %>
          <% end %>

          <%= link to: "#", phx_click: "add-to-next", phx_target: @myself, phx_value_id: track.id, class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do %>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
              <path d="M4.555 5.168A1 1 0 003 6v8a1 1 0 001.555.832L10 11.202V14a1 1 0 001.555.832l6-4a1 1 0 000-1.664l-6-4A1 1 0 0010 6v2.798l-5.445-3.63z" />
            </svg>
            <span>Add to next up</span>
          <% end %>

          <% #= link_to "Show this track", track, class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
          <% #= link_to 'Edit this track', edit_track_path(track), class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
        </div>
      </div>
    </div>


    """
  end
end
