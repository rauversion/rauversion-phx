defmodule RauversionWeb.TrackLive.TrackComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{track: track, current_user: current_user} = assigns) do
    ~H"""

    <div class="flex flex-col sm:flex-row border rounded-md shadow-sm my-2">
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
          <%= content_tag :div, "data-controller": "audio",
                                "data-audio-target": "player",
                                "data-audio-height-value": 70,
                                "data-audio-peaks": Jason.encode!(Rauversion.Tracks.metadata(track, "peaks")),
                                "data-audio-url": Rauversion.Tracks.blob_proxy_url(track, "mp3_audio"),
                                class: "h-32"  do %>
            <div class='controls flex items-center'>
              <span class="relative z-0 inline-flex py-2 px-2 sm:px-0">
                <button type="button"
                  data-action='audio#play'
                  data-audio-target="play"
                  class="relative inline-flex items-center px-2 py-2 rounded-full border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-10 focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500">
                  <span class="sr-only">Play</span>
                  <svg viewBox="0 0 15 15" class="h-6 w-6" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M4.5 12.5v-10l7 5-7 5z" stroke="currentColor" stroke-linejoin="round"></path></svg>
                </button>

                <button type="button"
                data-action='audio#pause'
                data-audio-target="pause"
                class="-ml-px relative inline-flex items-center px-2 py-2 rounded-full border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-10 focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500">
                  <span class="sr-only">Next</span>
                  <svg viewBox="0 0 15 15" class="h-6 w-6" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M11.5 3.5h-8v8h8v-8z" stroke="currentColor"></path></svg>
                </button>

              </span>
              <div class="ml-2">
                <h4 class="text-lg font-bold">
                  <%= live_redirect track.title, to: Routes.track_show_path(@socket, :show, track) %>
                </h4>
                <%= if track.user do %>
                  <h5 class="text-sm font-"><%= track.user.email %></h5>
                <% end %>
              </div>
            </div>
          <% end %>
        <% #end %>

        <p class="hidden mt-1 text-sm text-gray-500">
          <%= track.description %>
        </p>

        <div class="p-2 sm:p-0 sm:pt-2" data-turbo="false">
          <%= live_redirect "Show", to: Routes.track_show_path(@socket, :show, track), class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
          <%= if current_user && current_user.id == track.user_id do %>
            <%= live_patch "Edit", to: Routes.track_index_path(@socket, :edit, track), class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
            <%= link "Delete", to: "#", phx_click: "delete", phx_value_id: track.id, data: [confirm: "Are you sure?"], class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
          <% end %>
          <% #= link_to "Show this track", track, class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
          <% #= link_to 'Edit this track', edit_track_path(track), class: "inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" %>
        </div>
      </div>
    </div>


    """
  end
end
