defmodule RauversionWeb.TrackLive.TrackListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component
  alias Rauversion.Tracks

  @impl true
  def mount(socket) do
    # socket = assign(socket, :tracks, Tracks.list_tracks())
    {:ok, socket, temporary_assigns: [messages: []]}
  end

  def render(assigns) do
    ~H"""
    <div class="">
      <div class="space-y-6 lg:col-start-1 lg:col-span-2">
        <section aria-labelledby="applicant-information-title">
          <div class="bg-white border-r">
            <div class="px-4 py-5 sm:px-6">
              <div class="flex justify-between items-center">
                <h1 class="font-bold text-4xl">Tracks</h1>

                <%= live_patch "New Track", to: Routes.track_new_path(@socket, :new), class: "rounded-lg py-3 px-5 bg-blue-600 text-white block font-medium" %>

                <% #= link_to 'New track', new_track_path,
                #"data-turbo": false,
                #class: "rounded-lg py-3 px-5 bg-blue-600 text-white block font-medium" %>
              </div>
            </div>

            <div class="border-t border-gray-200 px-4 py-5 sm:px-6">

              <% # if notice.present? %>
                <p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block" id="notice">
                  <% #= notice %>
                </p>
              <% # end %>

              <div id="track-list" class="min-w-full">
                <%= for track <- @tracks do %>
                  <.live_component
                    module={RauversionWeb.TrackLive.TrackComponent}
                    id={"track-#{track.id}"}
                    track={track}
                  />
                <% end %>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
    """
  end
end
