defmodule RauversionWeb.TrackLive.TrackListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component
  alias Rauversion.{Tracks, Repo}

  @impl true
  def preload(assigns) do
    assigns = List.first(assigns)
    page = 1
    tracks = list_tracks(page, assigns)
    tracks_meta = track_meta(tracks)

    [
      Map.merge(assigns, %{
        page: 1,
        tracks: tracks,
        track_meta: tracks_meta
      })
    ]
  end

  @impl true
  def mount(socket) do
    {:ok, socket, temporary_assigns: [tracks: []]}
  end

  # @impl true
  # def update(assigns, socket) do
  #   tracks = list_tracks(assigns)

  #   {:ok,
  #    socket
  #    |> assign(assigns)
  #    |> assign(page: 1)
  #    |> assign(tracks: tracks)}
  # end

  defp list_tracks(page, assigns) do
    IO.inspect("OEIEIEIEIEIE")

    Tracks.list_tracks_by_username(assigns.profile.username)
    |> Tracks.preload_tracks_preloaded_by_user(assigns[:current_user])
    |> Repo.paginate(page: page, page_size: 5)
  end

  defp track_meta(tracks) do
    %{
      page_number: tracks.page_number,
      page_size: tracks.page_size,
      total_entries: tracks.total_entries,
      total_pages: tracks.total_pages
    }
  end

  @impl true
  def handle_event("paginate", %{}, socket) do
    if socket.assigns.page == socket.assigns.track_meta.total_pages do
      {:noreply, socket}
    else
      page = socket.assigns.page + 1

      tracks = list_tracks(page, socket.assigns)
      tracks_meta = track_meta(tracks)

      {:noreply,
       socket
       |> assign(:page, page)
       |> assign(:track_meta, tracks_meta)
       |> assign(:tracks, tracks.entries)}
    end
  end

  @impl true
  def handle_event("delete-track", %{"id" => id}, socket) do
    track = Tracks.get_track!(id)

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket, track.user_id) do
      {:ok, socket} ->
        {:ok, _} = Tracks.delete_track(track)
        {:noreply, push_event(socket, "remove-item", %{id: "track-item-#{track.id}"})}

      _err ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="">
      <div class="space-y-6 lg:col-start-1 lg:col-span-2">
        <section aria-labelledby="applicant-information-title">
          <div class="bg-white border-r">
            <div class="px-4 py-5 sm:px-6">
              <div class="flex justify-between items-center">
                <h1 class="font-bold text-4xl"><%= @title %></h1>

                <%= live_patch to: Routes.track_new_path(@socket, :new),
                 class: "inline-flex justify-between rounded-lg py-3 px-5 bg-black text-white block font-medium" do %>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" />
                  </svg>
                  <span>New Track</span>
                 <% end %>
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

              <div id="infinite-scroll"
                class="min-w-full"
                phx-hook="InfiniteScroll"
                phx-update="append"
                data-page={@page}
                phx-target={@myself}
                data-total-pages={assigns.track_meta.total_pages}
                data-paginate-end={assigns.track_meta.total_pages == @page}>
                <%= for track <- @tracks do %>
                  <.live_component
                    module={RauversionWeb.TrackLive.TrackComponent}
                    id={"track-list-#{track.id}"}
                    track={track}
                    repost={nil}
                    like={nil}
                    ref={@myself}
                    current_user={assigns[:current_user]}
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
