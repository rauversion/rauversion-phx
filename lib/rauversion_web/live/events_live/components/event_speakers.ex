defmodule RauversionWeb.EventsLive.EventSpeakers do
  use RauversionWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:days, get_days())
     |> assign(:day, List.first(get_days()))}
  end

  defp get_days() do
    [
      %{day: "April 4", title: "Opening day", performers: performers()},
      %{day: "April 5", title: "Speakers & Workshops", performers: performers()},
      %{day: "April 6", title: "Interviews", performers: performers()}
    ]
  end

  defp performers() do
    [%{name: "Steven McHail", title: "Designer at Globex Corporation"}]
  end

  def handle_event("day", params, socket) do
    {:noreply, assign(:day, List.first(socket.assigns.days))}
  end

  def render(assigns) do
    ~H"""

    <section id="speakers"
      aria-labelledby="speakers-title"
      class="py-20 sm:py-32">
      <svg aria-hidden="true" width="0" height="0">
        <defs>
          <clipPath id=":R9m:-0" clipPathUnits="objectBoundingBox">
            <path d="M0,0 h0.729 v0.129 h0.121 l-0.016,0.032 C0.815,0.198,0.843,0.243,0.885,0.243 H1 v0.757 H0.271 v-0.086 l-0.121,0.057 v-0.214 c0,-0.032,-0.026,-0.057,-0.057,-0.057 H0 V0"></path>
          </clipPath>
          <clipPath id=":R9m:-1" clipPathUnits="objectBoundingBox">
            <path d="M1,1 H0.271 v-0.129 H0.15 l0.016,-0.032 C0.185,0.802,0.157,0.757,0.115,0.757 H0 V0 h0.729 v0.086 l0.121,-0.057 v0.214 c0,0.032,0.026,0.057,0.057,0.057 h0.093 v0.7"></path>
          </clipPath>
          <clipPath id=":R9m:-2" clipPathUnits="objectBoundingBox">
            <path d="M1,0 H0.271 v0.129 H0.15 l0.016,0.032 C0.185,0.198,0.157,0.243,0.115,0.243 H0 v0.757 h0.729 v-0.086 l0.121,0.057 v-0.214 c0,-0.032,0.026,-0.057,0.057,-0.057 h0.093 V0"></path>
          </clipPath>
        </defs>
      </svg>

      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">

        <div class="mx-auto max-w-2xl lg:mx-0">
          <h2 id="speakers-title" class="font-display text-4xl font-medium tracking-tighter text-brand-600 sm:text-5xl">
            <%= gettext("Speakers") %>
          </h2>
          <p class="mt-4 font-display text-2xl tracking-tight text-brand-100">
            <%= @event.description %>
          </p>
        </div>

        <div class="mt-14 grid grid-cols-1 items-start gap-y-8 gap-x-8 sm:mt-16 sm:gap-y-16 lg:mt-24 lg:grid-cols-4">
          <div class="relative -mx-4 flex overflow-x-auto pb-4 sm:mx-0 sm:block sm:overflow-visible sm:pb-0">
            <div class="absolute bottom-0 top-2 left-0.5 hidden w-px bg-slate-200 lg:block"></div>
            <div class="grid auto-cols-auto grid-flow-col justify-start gap-x-8 gap-y-10 whitespace-nowrap px-4 sm:mx-auto sm:max-w-2xl sm:grid-cols-3 sm:px-0 sm:text-center lg:grid-flow-row lg:grid-cols-1 lg:text-left" role="tablist" aria-orientation="vertical">

              <%= for day <- @days do %>
                <div class="relative lg:pl-8">
                  <svg aria-hidden="true" viewBox="0 0 6 6" class="absolute top-[0.5625rem] left-[-0.5px] hidden h-1.5 w-1.5 overflow-visible lg:block fill-brand-600 stroke-brand-600">
                    <path d="M3 0L6 3L3 6L0 3Z" stroke-width="2" stroke-linejoin="round"></path>
                  </svg>

                  <div class="relative">
                    <div class="font-mono text-sm text-brand-600">
                      <button
                        phx-click={"day"}
                        phx-data={day.day}
                        phx-target={@myself}
                        class="[&amp;:not(:focus-visible)]:focus:outline-none"
                        role="tab"
                        type="button"
                        aria-selected="true"
                        tabindex="0">
                        <span class="absolute inset-0"></span>
                        <%= gettext("Opening Day") %>
                      </button>
                    </div>
                    <time
                      datetime="2022-04-04"
                      class="mt-1.5 block text-2xl font-semibold tracking-tight text-brand-900 dark:text-brand-100">
                      <%= day.day %>
                    </time>
                  </div>
                </div>
              <% end %>

            </div>
          </div>

          <div class="lg:col-span-3">
            <%= if @day do %>
              <div class="grid grid-cols-1 gap-x-8 gap-y-10 sm:grid-cols-2 sm:gap-y-16 md:grid-cols-3 [&amp;:not(:focus-visible)]:focus:outline-none"
                id="headlessui-tabs-panel-:Rql9m:"
                role="tabpanel">

                <%= for performer <- @day.performers do %>
                  <div>
                    <div class="group relative h-[17.5rem] transform overflow-hidden rounded-4xl">
                      <div class="absolute top-0 left-0 right-4 bottom-6 rounded-4xl border transition duration-300 group-hover:scale-95 xl:right-6 border-brand-300"></div>
                      <div class="absolute inset-0 bg-indigo-50" style="clip-path:url(#:R9m:-0)">
                        <img alt="" sizes="(min-width: 1280px) 17.5rem, (min-width: 1024px) 25vw, (min-width: 768px) 33vw, (min-width: 640px) 50vw, 100vw" srcset="/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=256&amp;q=75 256w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=384&amp;q=75 384w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=640&amp;q=75 640w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=750&amp;q=75 750w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=828&amp;q=75 828w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=1080&amp;q=75 1080w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=1200&amp;q=75 1200w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=1920&amp;q=75 1920w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=2048&amp;q=75 2048w, /_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=3840&amp;q=75 3840w" src="/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fsteven-mchail.4e94472e.jpg&amp;w=3840&amp;q=75" width="1120" height="560" decoding="async" data-nimg="future" class="absolute inset-0 h-full w-full object-cover transition duration-300 group-hover:scale-110">
                      </div>
                    </div>
                    <h3 class="mt-8 font-display text-xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                      <%= performer.name %>
                    </h3>
                    <p class="mt-1 text-base tracking-tight text-slate-500 dark:text-slate-300">
                      <%= performer.title %>
                    </p>
                  </div>
                <% end %>

              </div>
            <% end %>
          </div>
        </div>
      </div>
    </section>

    """
  end
end
