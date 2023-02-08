defmodule RauversionWeb.EventsStreamingLive.Show do
  use RauversionWeb, :live_view
  on_mount(RauversionWeb.UserLiveAuth)

  alias Rauversion.{Events, Repo}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:open, false)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    case apply_action(socket, socket.assigns.live_action, params) do
      {:ok, reply} ->
        {:noreply, reply}

      {:err, err} ->
        {:noreply, err}

      any ->
        {:noreply, any}
    end
  end

  defp apply_action(socket, :show, %{"id" => _id, "provider" => provider}) do
    case Events.verify_streaming_access_for(provider) do
      %Events.Event{} = event ->
        event = Events.get_event!(event.id) |> Repo.preload([:user])

        service =
          PolymorphicEmbed.get_polymorphic_type(
            Events.Event,
            :streaming_service,
            event.streaming_service
          )
          |> Atom.to_string()

        socket |> assign(:event, event) |> assign(:provider, service)

      _ ->
        socket
        |> put_flash(:error, "Event not found")
        |> push_redirect(to: "/")
    end
  end

  def restream_renderer(assigns) do
    ~H"""
    <div style="padding:56.25% 0 0 0;position:relative;">
      <iframe
        src={@event.streaming_service.player_url}
        allow="autoplay"
        allowfullscreen
        frameborder="0"
        style="position:absolute;top:0;left:0;width:100%;height:100%;"
      />
    </div>
    """
  end

  def twitch_renderer(assigns) do
    ~H"""
    <div id="twitch-wrapper" phx-update="ignore">
      <script src="https://player.twitch.tv/js/embed/v1.js">
      </script>
      <div id="twitch-div"></div>
      <script type="text/javascript">
        var options = {
          width: '100%',
          height: '520',
          <%= @event.streaming_service.streaming_type %>: "<%= @event.streaming_service.streaming_identifier %>"
          //channel: "<channel ID>",
          // video: "738688473",
          //collection: "<collection ID>",
          // only needed if your site is also embedded on embed.example.com and othersite.example.com
          //parent: ["embed.example.com", "othersite.example.com"]
        };
        var player = new Twitch.Player("twitch-div", options);
        player.setVolume(0.5);
      </script>
    </div>
    """
  end

  def whereby_renderer(assigns) do
    ~H"""
    <div id="whereby_renderer" phx-update="ignore">
      <iframe
        width="100%"
        height="520"
        src={"#{assigns.event.streaming_service.room_url}?video=off&audio=off&people=off&precallReview=off"}
        allow="camera; microphone; fullscreen; speaker; display-capture; autoplay"
      >
      </iframe>
    </div>
    """
  end

  def mux_renderer(assigns) do
    ~H"""
    <div class="w-full h-[520px]" id="mux_renderer" phx-update="ignore">
      <script src="https://unpkg.com/@mux/mux-player">
      </script>
      <mux-player
        stream-type="on-demand"
        playback-id={assigns.event.streaming_service.playback_url}
        metadata-video-title={assigns.event.streaming_service.title || "streaming video"}
        metadata-viewer-user-id="user-id-007"
      >
      </mux-player>
    </div>
    """
  end

  def jitsi_renderer(assigns) do
    ~H"""
    <div class="w-full h-[520px]">
      <div id="jitsi-meet" phx-update="ignore"></div>
      <script src="https://meet.jit.si/external_api.js">
      </script>
      <script>
        const domain = 'meet.jit.si';
        const options = {
            roomName: 'JitsiMeetAPIExample',
            width: 600,
            height: 500,
            parentNode: document.querySelector('#jitsi-meet'),
            lang: 'es'
        };
        const api = new JitsiMeetExternalAPI(domain, options);
      </script>
    </div>
    """
  end

  def zoom_renderer(assigns) do
    ~H"""
    <div class="flex justify-center flex-col space-y-3">
      <p class="text-lg">
        <%= gettext("Player not available please open the metting on Zoom service") %>
      </p>
      <a
        href={assigns.streaming_event.meeting_url}
        target="blank"
        class="inline-flex items-center justify-center rounded-md border border-transparent bg-brand-600 px-5 py-3 text-base font-medium text-white hover:bg-brand-700"
      >
        <%= gettext("Go to the Zoom meeting") %>
      </a>
    </div>
    """
  end

  def stream_yard_renderer(assigns) do
    ~H"""
    <div class="flex justify-center flex-col space-y-3" id="stream_yard_renderer" phx-update="ignore">
      <iframe
        width="100%"
        height="520"
        src={assigns.event.streaming_service.youtube_url}
        title=""
        frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      >
      </iframe>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative bg-white dark:bg-black dark:text-white py-16 sm:py-24">
      <div class="lg:mx-auto lg:grid lg:max-w-7xl lg:grid-cols-2 lg:items-start lg:gap-24 lg:px-8">
        <div class="relative sm:py-16 lg:py-0">
          <div
            aria-hidden="true"
            class="hidden sm:block lg:absolute lg:inset-y-0 lg:right-0 lg:w-screen"
          >
            <div class="absolute inset-y-0 right-1/2 w-full rounded-r-3xl bg-gray-50 dark:bg-gray-900 lg:right-72">
            </div>
            <svg
              class="absolute top-8 left-1/2 -ml-3 lg:-right-8 lg:left-auto lg:top-12"
              width="404"
              height="392"
              fill="none"
              viewBox="0 0 404 392"
            >
              <defs>
                <pattern
                  id="02f20b47-fd69-4224-a62a-4c9de5c763f7"
                  x="0"
                  y="0"
                  width="20"
                  height="20"
                  patternUnits="userSpaceOnUse"
                >
                  <rect
                    x="0"
                    y="0"
                    width="4"
                    height="4"
                    class="text-gray-200 dark:text-gray-800"
                    fill="currentColor"
                  />
                </pattern>
              </defs>
              <rect width="404" height="392" fill="url(#02f20b47-fd69-4224-a62a-4c9de5c763f7)" />
            </svg>
          </div>
          <div class="relative mx-auto max-w-md px-4 sm:max-w-3xl sm:px-6 lg:max-w-none lg:px-0 lg:py-20">
            <!-- Testimonial card-->
            <div
              class="relative overflow-hidden rounded-2xl pt-64- pb-10- shadow-xl"
              id="streaming-renderer"
            >
              <!--<img class="absolute inset-0 h-full w-full object-cover" src="https://images.unsplash.com/photo-1521510895919-46920266ddb3?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&fp-x=0.5&fp-y=0.6&fp-z=3&width=1440&height=1440&sat=-100" alt="">
                <div class="absolute inset-0 bg-brand-500 mix-blend-multiply"></div>
                <div class="absolute inset-0 bg-gradient-to-t from-brand-600 via-brand-600 opacity-90"></div>-->
              <%= case @provider do %>
                <% "twitch" -> %>
                  <.twitch_renderer event={@event}></.twitch_renderer>
                <% "whereby" -> %>
                  <.whereby_renderer event={@event}></.whereby_renderer>
                <% "mux" -> %>
                  <.mux_renderer event={@event}></.mux_renderer>
                <% "jitsi" -> %>
                  <.jitsi_renderer event={@event}></.jitsi_renderer>
                <% "zoom" -> %>
                  <.zoom_renderer event={@event}></.zoom_renderer>
                <% "stream_yard" -> %>
                  <.stream_yard_renderer event={@event}></.stream_yard_renderer>
                <% "restream" -> %>
                  <.restream_renderer event={@event}></.restream_renderer>
                <% _ -> %>
                  <div class="flex items-start space-x-3 ">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="1.5"
                      stroke="currentColor"
                      class="w-6 h-6"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
                      />
                    </svg>
                    <span>
                      <%= gettext("no renderer avaiable") %>
                    </span>
                  </div>
              <% end %>
              <!--
                <div class="relative px-8">
                  <div>
                    <img class="h-12" src="https://tailwindui.com/img/logos/workcation.svg?color=white" alt="Workcation">
                  </div>
                  <blockquote class="mt-8">
                    <div class="relative text-lg font-medium text-white md:flex-grow">
                      <svg class="absolute top-0 left-0 h-8 w-8 -translate-x-3 -translate-y-2 transform text-brand-400" fill="currentColor" viewBox="0 0 32 32" aria-hidden="true">
                        <path d="M9.352 4C4.456 7.456 1 13.12 1 19.36c0 5.088 3.072 8.064 6.624 8.064 3.36 0 5.856-2.688 5.856-5.856 0-3.168-2.208-5.472-5.088-5.472-.576 0-1.344.096-1.536.192.48-3.264 3.552-7.104 6.624-9.024L9.352 4zm16.512 0c-4.8 3.456-8.256 9.12-8.256 15.36 0 5.088 3.072 8.064 6.624 8.064 3.264 0 5.856-2.688 5.856-5.856 0-3.168-2.304-5.472-5.184-5.472-.576 0-1.248.096-1.44.192.48-3.264 3.456-7.104 6.528-9.024L25.864 4z" />
                      </svg>
                      <p class="relative">Tincidunt integer commodo, cursus etiam aliquam neque, et. Consectetur pretium in volutpat, diam. Montes, magna cursus nulla feugiat dignissim id lobortis amet.</p>
                    </div>

                    <footer class="mt-4">
                      <p class="text-base font-semibold text-brand-200">Sarah Williams, CEO at Workcation</p>
                    </footer>
                  </blockquote>
                </div>
                -->
            </div>
          </div>
        </div>

        <div class="relative mx-auto max-w-md px-4 sm:max-w-3xl sm:px-6 lg:px-0">
          <!-- Content area -->
          <div class="pt-12 sm:pt-16 lg:pt-20">
            <h2 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl">
              <%= @event.title %>
            </h2>
            <div class="mt-6 space-y-6 text-gray-500 dar:text-gray-300">
              <p class="text-lg"><%= @event.description %></p>
              <!--
                  <p class="text-base leading-7">Sollicitudin tristique eros erat odio sed vitae, consequat turpis elementum. Lorem nibh vel, eget pretium arcu vitae. Eros eu viverra donec ut volutpat donec laoreet quam urna. Sollicitudin tristique eros erat odio sed vitae, consequat turpis elementum. Lorem nibh vel, eget pretium arcu vitae. Eros eu viverra donec ut volutpat donec laoreet quam urna.</p>
                  <p class="text-base leading-7">Rhoncus nisl, libero egestas diam fermentum dui. At quis tincidunt vel ultricies. Vulputate aliquet velit faucibus semper. Pellentesque in venenatis vestibulum consectetur nibh id. In id ut tempus egestas. Enim sit aliquam nec, a. Morbi enim fermentum lacus in. Viverra.</p>
                -->
            </div>
          </div>
          <!-- Stats section -->
          <div class="mt-10">
            <!--
              <dl class="grid grid-cols-2 gap-x-4 gap-y-8">
                <div class="border-t-2 border-gray-100 pt-6">
                  <dt class="text-base font-medium text-gray-500">Founded</dt>
                  <dd class="text-3xl font-bold tracking-tight text-gray-900">2021</dd>
                </div>

                <div class="border-t-2 border-gray-100 pt-6">
                  <dt class="text-base font-medium text-gray-500">Employees</dt>
                  <dd class="text-3xl font-bold tracking-tight text-gray-900">5</dd>
                </div>

                <div class="border-t-2 border-gray-100 pt-6">
                  <dt class="text-base font-medium text-gray-500">Beta Users</dt>
                  <dd class="text-3xl font-bold tracking-tight text-gray-900">521</dd>
                </div>

                <div class="border-t-2 border-gray-100 pt-6">
                  <dt class="text-base font-medium text-gray-500">Raised</dt>
                  <dd class="text-3xl font-bold tracking-tight text-gray-900">$25M</dd>
                </div>
              </dl>
              -->
            <div class="mt-10">
              <%= live_redirect to: "/events/",
                  class: "text-base font-medium text-brand-600" do %>
                <%= gettext("Go and check the event details") %>
                <span aria-hidden="true"> &rarr;</span>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
