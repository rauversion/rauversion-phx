defmodule RauversionWeb.TrackLive.Player do
  use RauversionWeb, :live_view

  alias Rauversion.Tracks

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:track, nil)
     |> assign(:index, 0)
     |> assign(:volume, false)
     |> assign(:slideover, false)
     |> assign(:play_index, 0)
     |> assign(:tracks, [])}
  end

  @impl true
  def handle_event("request-song", %{"id" => id}, socket) do
    track = Tracks.get_track!(id) |> Rauversion.Repo.preload([:user, :mp3_audio_blob])
    {:noreply, socket |> assign(:track, track) |> push_event("play-song", %{})}
  end

  @impl true
  def handle_event("request-song", %{"action" => action}, socket) do
    # track = Tracks.get_track!(id) |> Rauversion.Repo.preload([:user, :mp3_audio_blob])

    index =
      case action do
        "next" -> socket.assigns.index + 1
        "prev" -> socket.assigns.index - 1
      end

    track = Enum.at(socket.assigns.tracks, index)

    {:noreply,
     socket
     |> assign(:track, track)
     |> assign(:index, index)
     |> push_event("play-song", %{})}
  end

  @impl true
  def handle_event("display-slideover", _, socket) do
    {:noreply, socket |> assign(:slideover, !socket.assigns.slideover)}
  end

  @impl true
  def handle_event("toggle-volume", _, socket) do
    {:noreply, socket |> assign(:volume, !socket.assigns.volume)}
  end

  @impl true
  def handle_event("clear-all", _, socket) do
    track = List.last(socket.assigns.tracks)
    {:noreply, socket |> assign(:tracks, [track])}
  end

  @impl true
  def handle_event("add-song", %{"id" => id}, socket) do
    track = Tracks.get_track!(id) |> Rauversion.Repo.preload([:user, :mp3_audio_blob])

    {
      :noreply,
      socket
      |> assign(:tracks, socket.assigns.tracks ++ [track])
      # |> push_event("play-song", %{})
    }
  end

  @impl true
  def handle_event("play-song", %{"id" => id}, socket) do
    track = Tracks.get_track!(id) |> Rauversion.Repo.preload([:user, :mp3_audio_blob])

    {:noreply,
     socket
     |> assign(:tracks, socket.assigns.tracks ++ [track])
     |> assign(:track, track)
     |> push_event("play-song", %{})}
  end

  @impl true
  def handle_event("remove-from-next-up", %{"index" => index}, socket) do
    {i, _} = Integer.parse(index)
    tracks = List.delete_at(socket.assigns.tracks, i)
    track = Enum.at(tracks, i)

    {:noreply,
     socket
     |> assign(:tracks, tracks)
     |> assign(:track, track)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id="main-player"
      class="z-50 fixed bottom-0 w-full h-[6rem]-- py-2 bg-gray-900">

      <%= if @track do %>
        <div
          id="main-player-component"
          phx-hook="Player"
          data-controller-disss="player"
          data-track-id={@track.id}
          data-player-peaks={ Jason.encode!(Rauversion.Tracks.metadata(@track, :peaks))}
          data-player-url={ Rauversion.Tracks.blob_proxy_url(@track, "mp3_audio")}
          class="flex">

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

          <div id="player-main-player" phx-update="ignore"
          data-player-target="player"
          class="mx-3 flex-grow items-center">
          </div>

          <div class="mx-3 w-1/4">

            <div class="py-0 px-2 h-12 leading-4 box-border text-zinc-200 flex">

              <%= if @track do %>

                <div class="flex items-center mx-2">
                  <div class="relative">
                    <div class={" #{if @volume do "" else "hidden" end} h-[115px] absolute top-[-8em] left-[-25px] bg-white border shadow-md"}>
                      <input
                        type="range"
                        min="0" max="1" step="0.1"
                        class="vertical mt-[52px]"
                        id="player-range"
                      />
                    </div>

                    <button class="text-white" phx-click="toggle-volume">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
                      </svg>
                    </button>
                  </div>
                </div>

                <div class="flex items-center h-full leading-4 text-zinc-300">
                  <%= live_redirect to: Routes.track_show_path(@socket, :show, @track), class: "float-left my-0 mr-2 ml-0 text-blue-500 cursor-pointer hover:text-zinc-100" do %>
                    <div
                      class="block relative w-8 h-8 text-center bg-no-repeat bg-cover"
                      style="height: 30px; width: 30px;">

                      <%= img_tag(Rauversion.Tracks.variant_url(
                          @track, "cover", %{resize_to_limit: "360x360"}),
                          class: "block relative w-8 h-8 opacity-100")
                      %>
                    </div>
                  <% end %>

                  <div class="flex-grow w-0-- leading-6">
                    <%= live_redirect to: Routes.track_show_path(@socket, :show, @track), class: "flex items-center w-full h-4 text-xs cursor-pointer truncate text-neutral-200 focus:text-black hover:text-neutral-300", title: @track.title do %>
                      <%= @track.user.username %>
                    <% end %>

                    <div class="flex items-center w-full h-4 text-zinc-800">
                      <%= live_redirect to: Routes.track_show_path(@socket, :show, @track), class: "text-xs cursor-pointer truncate text-stone-200 focus:text-black hover:text-neutral-200", title: @track.title  do %>
                        <span class="sr-only">Current track: <%= @track.title %></span>
                        <span aria-hidden="true" class="whitespace-nowrap"><%= @track.title %></span>
                      <% end %>
                    </div>
                  </div>

                  <div class="flex ml-2 text-zinc-200 ">


                    <button
                      type="button"
                      class="hidden inline-block relative p-3 m-0 h-5 font-sans font-thin text-left text-orange-600 whitespace-nowrap bg-transparent rounded-sm border-0 border-solid cursor-pointer select-none box-border border-neutral-200 focus:border focus:border-solid focus:border-orange-600 focus:text-orange-600 hover:border hover:border-solid hover:border-orange-600 hover:text-orange-600"
                      aria-describedby="tooltip-1455"
                      tabindex="0"
                      title="Unlike"
                      aria-label="Unlike">
                      Liked
                    </button>

                    <button
                      type="button"
                      class="hidden inline-block relative p-3 m-0 h-5 font-sans font-thin text-left whitespace-nowrap bg-transparent rounded-sm border-0 border-solid cursor-pointer select-none box-border border-neutral-200 focus:border-stone-300 focus:text-zinc-800 hover:border-stone-300 hover:text-zinc-800"
                      tabindex="0"
                      title="Follow"
                      aria-label="Follow">
                      Follow
                    </button>

                    <button phx-click="display-slideover">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 10h16M4 14h16M4 18h16" />
                      </svg>
                    </button>


                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>

      <%= if @slideover do %>
        <div style="height: calc(100% - 64px);" class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
          <div class="pointer-events-auto w-screen max-w-md">
            <div class="flex h-full flex-col overflow-y-scroll bg-white py-6 shadow-xl">
              <div class="px-4 sm:px-6">
                <div class="flex items-start justify-between">
                  <h2 class="text-lg font-medium text-gray-900" id="slide-over-title">Next up</h2>
                  <button type="button"
                      phx-click="clear-all"
                      class="rounded-md bg-white text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">
                      clear all
                    </button>

                  <div class="ml-3 flex h-7 items-center">
                    <button type="button"
                      phx-click="display-slideover"
                      class="rounded-md bg-white text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">
                      <span class="sr-only">Close panel</span>
                      <!-- Heroicon name: outline/x -->
                      <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
              <div class="relative mt-6 flex-1 px-4 sm:px-6">
                <!-- Replace with your content -->
                <div class="absolute inset-0 px-4 sm:px-6">
                  <div class="h-full" aria-hidden="true">


                    <div class="flow-root mt-6">
                      <ul role="list" class="-my-5 divide-y divide-gray-200 h-full">

                        <%= for {item, counter} <- Enum.with_index(@tracks) do %>
                         <% #= for item <- @tracks  do %>
                          <li class={"py-4 px-2 #{if counter == @index do "bg-gray-100" else "" end }"}>
                            <div class="flex items-center space-x-4">
                              <div class="flex-shrink-0">
                                <%= img_tag(Rauversion.Tracks.variant_url(
                                  item, "cover", %{resize_to_limit: "360x360"}),
                                  class: "h-8 w-8 rounded-full")
                                %>
                              </div>
                              <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-gray-900 truncate"><%= item.title %></p>
                                <p class="text-sm text-gray-500 truncate"><%= item.user.username %></p>
                              </div>
                              <div class="">
                                <a href="#"
                                  phx-click="remove-from-next-up"
                                  phx-value-index={counter}
                                  class="inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50">
                                  remove from next up
                                </a>
                              </div>
                            </div>
                          </li>
                        <% end %>
                      </ul>
                    </div>

                  </div>
                </div>
                <!-- /End replace -->
              </div>
            </div>
          </div>
        </div>
      <% end %>

    </div>
    """
  end
end
