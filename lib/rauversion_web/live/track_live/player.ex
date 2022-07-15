defmodule RauversionWeb.TrackLive.Player do
  use RauversionWeb, :live_view

  alias Rauversion.Tracks

  @impl true
  def mount(_params, _session, socket) do
    track = Tracks.get_track!(80) |> Rauversion.Repo.preload([:user, :mp3_audio_blob])
    {:ok, socket |> assign(:track, track)}
  end

  @impl true
  def handle_event("request-song", %{"id" => id}, socket) do
    track = Tracks.get_track!(id) |> Rauversion.Repo.preload([:user, :mp3_audio_blob])

    # data = %{
    #  id: track.id,
    #  peaks: Jason.encode!(Rauversion.Tracks.metadata(track, :peaks)),
    #  url: Rauversion.Tracks.blob_proxy_url(track, "mp3_audio"),
    #  image: Rauversion.Tracks.blob_url(track, "cover"),
    #  title: track.title,
    #  username: track.user.username
    # }

    # {:noreply, push_event(socket, "play-song", data)}

    {:noreply, socket |> assign(:track, track) |> push_event("play-song", %{})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="main-player"
      phx-hook="Player"
      phx-update="ignore"
      data-controller-disss="player"
      data-player-peaks={ Jason.encode!(Rauversion.Tracks.metadata(@track, :peaks))}
      data-player-url={ Rauversion.Tracks.blob_proxy_url(@track, "mp3_audio")}
      class="z-50 fixed bottom-0 w-full h-[6rem]-- py-2 bg-gray-900">

      <div class="flex">

        <div class="flex text-white items-center justify-center space-x-3">
          <div></div>

          <button type="button"
            data-action='player#rew'
            data-player-target="rew">
            <svg viewBox="0 0 15 15"
              aria-label="fwd"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
              width="15" height="15">
              <path d="M14.5 12.5v-10l-7 5 7 5zm-7 0v-10l-7 5 7 5z" stroke="currentColor" stroke-linejoin="round"></path>
            </svg>
          </button>

          <button type="button"
            data-action='player#pause'
            data-player-target="pause"
            class="hidden -ml-px relative inline-flex items-center px-2 py-2 rounded-full border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-10 focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500">
            <span class="sr-only">Next</span>
            <svg viewBox="0 0 15 15" class="h-6 w-6" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M11.5 3.5h-8v8h8v-8z" stroke="currentColor"></path></svg>
          </button>

          <button type="button"
            data-action='player#play'
            data-player-target="play"
            class="relative inline-flex items-center px-2 py-2 rounded-full border border-orange-300 bg-orange-600 text-sm font-medium text-white hover:bg-orange-500 focus:z-10 focus:outline-none focus:ring-1 focus:ring-orange-700 focus:border-orange-400">
            <span class="sr-only">Play</span>
            <svg data-player-target="playicon" style="display:none" viewBox="0 0 15 15" class="h-6 w-6"  fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M5.5 3v9m4-9v9" stroke="currentColor"></path></svg>
            <svg data-player-target="pauseicon"  viewBox="0 0 15 15" class="h-6 w-6" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M4.5 12.5v-10l7 5-7 5z" stroke="currentColor" stroke-linejoin="round"></path></svg>
          </button>

          <button type="button"
            data-action='player#next'
            data-player-target="next">
            <svg viewBox="0 0 15 15" aria-label="fwd" fill="none" xmlns="http://www.w3.org/2000/svg" width="15" height="15"><path d="M.5 12.5v-10l7 5-7 5zm7 0v-10l7 5-7 5z" stroke="currentColor" stroke-linejoin="round"></path></svg>
          </button>
        </div>

        <div data-player-target="player" class="mx-3 flex-grow items-center">
        </div>

        <div class="mx-3">

          <div class="py-0 px-2 h-12 leading-4 box-border text-zinc-200">
            song info
            <% #= :os.system_time(:millisecond) %>
          </div>


        </div>

      </div>

      <div class="absolute right-0 border-2 top-[-5em] bg-gray-800 text-gray-100">
        <div class="p-4">
          olii
        </div>
      </div>

    </div>
    """
  end
end
