defmodule RauversionWeb.EventsLive.EventSpeakers do
  use RauversionWeb, :live_component

  alias Rauversion.Events

  def update(assigns, socket) do
    days = get_days(assigns.event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:days, days)
     |> assign(:day, List.first(days))}
  end

  defp get_days(event) do
    event.scheduling_settings
    |> Enum.map(fn x ->
      %{
        day: Events.simple_date_for(x.start_date)
      }
      |> Map.merge(x)
    end)
  end

  defp performers(event) do
    Rauversion.Events.get_hosts(event, true)
  end

  def handle_event("day", _params, socket) do
    {:noreply, assign(:day, List.first(socket.assigns.days))}
  end

  def render_date(date, tz \\ "Etc/UTC") do
    Rauversion.Dates.format_time(date,
      locale: "en-US",
      timezone: tz,
      format: "hh:mm a"
    )
  end

  def render(assigns) do
    ~H"""

    <div>

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
            <%= @event.event_settings.participant_label %>
          </h2>
          <p class="mt-4 font-display text-2xl tracking-tight text-brand-100">
            <%= @event.event_settings.participant_description %>
          </p>
        </div>

        <div class="mt-14 grid grid-cols-1 items-start gap-y-8 gap-x-8 sm:mt-16 sm:gap-y-16 lg:mt-24 lg:grid-cols-4">
          <div class="relative -mx-4 flex overflow-x-auto pb-4 sm:mx-0 sm:block sm:overflow-visible sm:pb-0">
            <div class="absolute bottom-0 top-2 left-0.5 hidden w-px bg-slate-200 lg:block"></div>
            <div class="grid auto-cols-auto grid-flow-col justify-start gap-x-8 gap-y-10 whitespace-nowrap px-4 sm:mx-auto sm:max-w-2xl sm:grid-cols-3 sm:px-0 sm:text-center lg:grid-flow-row lg:grid-cols-1 lg:text-left"
              role="tablist"
              aria-orientation="vertical">

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
                        <%= day.name %>
                      </button>
                    </div>
                    <time
                      datetime={day.start_date}
                      class="mt-1.5 block text-2xl font-semibold tracking-tight text-brand-900 dark:text-brand-100">
                      <%= Rauversion.Events.simple_date_for(day.day) %>
                    </time>
                  </div>
                </div>
              <% end %>

            </div>
          </div>

          <div class="lg:col-span-3">
            <%= if @day do %>
              <div class="grid grid-cols-1 gap-x-8 gap-y-10 sm:grid-cols-2 sm:gap-y-16 md:grid-cols-3 [&amp;:not(:focus-visible)]:focus:outline-none"
                role="tabpanel">

                <%= for performer <- performers(@event) do %>
                  <div>
                    <div class="group relative h-[17.5rem] transform overflow-hidden rounded-4xl- rounded-full">
                      <div class="absolute top-0 left-0 right-4 bottom-6 rounded-4xl border transition duration-300 group-hover:scale-95 xl:right-6 border-brand-300"></div>
                      <div class="absolute inset-0 bg-indigo-50 rounded-full" style="clip-path:url(#:R9m:-0)">
                        <%= if performer.avatar_blob do %>
                          <%= img_tag(Rauversion.BlobUtils.blob_representation_proxy_url( performer, "avatar", %{resize_to_fill: "300x300"}), class: "object-center object-cover group-hover:opacity-75 w-full") %>
                        <% else %>
                          <%= if performer.user && performer.user.username do %>
                            <%= live_redirect to: Routes.profile_index_path(@socket, :index, performer.user.username) do %>
                              <%= img_tag(Rauversion.BlobUtils.blob_representation_proxy_url( performer.user, "avatar", %{resize_to_fill: "300x300"}), class: "object-center object-cover group-hover:opacity-75 w-full") %>
                            <% end %>
                          <% end %>

                          <%= if performer.user && !performer.user.username do %>
                            <%= img_tag(Rauversion.BlobUtils.blob_representation_proxy_url( performer.user, "avatar", %{resize_to_fill: "300x300"}), class: "object-center object-cover group-hover:opacity-75 w-full") %>
                          <% end %>


                        <% end %>
                      </div>
                    </div>
                    <h3 class="mt-8 font-display text-xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                      <%= if performer.name do %>

                        <%= if performer.user && performer.user.first_name && performer.user.username do %>
                          <%= live_redirect to: Routes.profile_index_path(@socket, :index, performer.user.username) do %>
                            <%= performer.name %>
                          <% end %>
                        <% else %>
                          <%= performer.name %>
                        <% end %>
                      <% end %>

                      <%= if !performer.name && performer.user && performer.user.first_name && performer.user.username do %>
                        <%= live_redirect to: Routes.profile_index_path(@socket, :index, performer.user.username) do %>
                          <%= "#{performer.user.first_name} #{performer.user.last_name}" %>
                        <% end %>
                      <% end %>

                      <%= if !performer.name && performer.user && performer.user.first_name && !performer.user.username do %>
                          <%= "#{performer.user.first_name} #{performer.user.last_name}" %>
                      <% end %>

                    </h3>
                    <div class="mt-1 text-base tracking-tight text-slate-500 dark:text-slate-300">
                      <%= SimplexFormat.text_to_html(performer.description, auto_link: true) %>
                    </div>
                  </div>
                <% end %>

              </div>
            <% end %>
          </div>
        </div>
      </div>
    </section>


    <section aria-label="Schedule" class="py-20 sm:py-32">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
        <div class="mx-auto max-w-2xl lg:mx-0 lg:max-w-4xl lg:pr-24">
          <h2 class="font-display text-4xl font-medium tracking-tighter text-brand-600 sm:text-5xl">
            <%= @event.event_settings.scheduling_label %>
          </h2>
          <div class="mt-4 font-display text-2xl tracking-tight text-brand-100">
            <%= SimplexFormat.text_to_html(@event.event_settings.scheduling_description, auto_link: true) %>
          </div>
        </div>
      </div>

      <div class="relative mt-14 sm:mt-24">
        <div class="absolute inset-x-0 -top-40 -bottom-32 overflow-hidden bg-black">
          <img src={ Routes.static_path(@socket, "/images/denys-churchyn-Kwmz_c_NiYk-unsplash.jpg")}
            width="918" height="1495"
            decoding="async"
            data-nimg="1"
            class="absolute left-full top-0 -translate-x-1/2 sm:left-1/2 sm:translate-y-[-15%] sm:translate-x-[-20%] md:translate-x-0 lg:translate-x-[5%] lg:translate-y-[4%] xl:translate-y-[-8%] xl:translate-x-[27%]"
            style="color:transparent">
          <div class="absolute inset-x-0 top-0 h-40 bg-gradient-to-b from-black"></div>
          <div class="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-black"></div>
        </div>

        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative">

          <div class="mx-auto grid max-w-2xl grid-cols-1 gap-y-6 sm:grid-cols-2 lg:hidden">
            <div class="-mx-4 flex gap-x-4 gap-y-10 overflow-x-auto pl-4 pb-4 sm:mx-0 sm:flex-col sm:pb-0 sm:pl-0 sm:pr-8"
              role="tablist"
              aria-orientation="vertical">
              <%= for day <- @days do %>
                <div class="relative w-3/4 flex-none pr-4 sm:w-auto sm:pr-0">
                  <h3 class="text-2xl font-semibold tracking-tight text-brand-900 dark:text-brand-100">
                    <time datetime="2022-04-04">
                      <button class="[&amp;:not(:focus-visible)]:focus:outline-none"
                          role="tab"
                          type="button"
                          aria-selected="true"
                          tabindex="0">
                        <span class="absolute inset-0"></span>
                        <time datetime={day.start_date}>
                          <%= Events.simple_date_for(day.start_date) %>
                        </time>
                        </button>
                    </time>
                  </h3>
                  <p class="mt-1.5 text-base tracking-tight text-brand-900 dark:text-brand-100 break-words">
                    <%= @day.description %>
                  </p>
                </div>
              <% end %>
            </div>
            <div>
              <%= for scheduling <- @days |> Enum.map(fn x -> x.schedulings end) |> List.flatten do %>
              <div class="[&amp;:not(:focus-visible)]:focus:outline-none" role="tabpanel" tabindex="0">
                <ol role="list" class="space-y-8 bg-white/60 dark:bg-white/10 py-14 px-10 text-center shadow-xl shadow-brand-900/5 backdrop-blur">
                  <li aria-label={"#{scheduling.title} #{scheduling.short_description} at 9:00AM - 10:00AM PST"}>
                    <h4 class="text-lg font-semibold tracking-tight text-brand-900 dark:text-brand-100">
                      <%= scheduling.title %>
                    </h4>
                    <p class="mt-1 tracking-tight text-brand-900 dark:text-brand-100">
                      <%= scheduling.short_description %>
                    </p>
                    <p class="mt-1 font-mono text-sm text-gray-500 dark:text-gray-300">
                      <!--<time datetime="2022-04-04T9:00AM-08:00">9:00AM</time>-->
                      <!-- - -->
                      <!-- -->
                      <!--<time datetime="2022-04-04T10:00AM-08:00">10:00AM</time>-->
                      <!-- -->
                      <%= render_date(scheduling.start_date, @timezone) %>
                      -
                      <%= render_date(scheduling.end_date, @timezone) %>
                    </p>
                  </li>
                </ol>
              </div>
              <% end %>
            </div>

          </div>

          <div class="hidden lg:grid lg:grid-cols-3 lg:gap-x-8">
            <%= for day <- @days do %>
              <section>

                <h3 class="text-2xl font-semibold tracking-tight text-brand-900 dark:text-brand-100">
                  <time datetime={day.start_date}>
                    <%= Events.simple_date_for(Rauversion.Dates.convert_date(day.start_date, @timezone)) %>
                  </time>
                </h3>

                <p class="mt-1.5 text-base tracking-tight text-brand-900 dark:text-brand-100">
                  <%= day.description %>
                </p>

                <%= if Enum.any?(day.schedulings) do %>
                  <ol role="list" class="mt-10 space-y-8 dark:bg-gray-900 --dark:bg-black/60 bg-white/60 py-14 px-10 text-center shadow-xl shadow-brand-900/5 backdrop-blur">
                    <%= for scheduling <- day.schedulings do %>
                      <li>
                        <div class="mx-auto mb-8 h-px w-48 bg-gray-200/10"></div>
                        <h4 class="text-lg font-semibold tracking-tight text-brand-900 dark:text-brand-100">
                          <%= scheduling.title %>
                        </h4>
                        <p class="mt-1 tracking-tight text-brand-900 dark:text-brand-100">
                          <%= scheduling.short_description %>
                        </p>
                        <p class="mt-1 font-mono text-sm text-gray-500 dark:text-gray-300">
                          <!--<time datetime="2022-04-04T9:00AM-08:00">9:00AM</time>-->
                          <!-- - -->
                          <!-- -->
                          <!--<time datetime="2022-04-04T10:00AM-08:00">10:00AM</time>-->
                          <!-- -->
                          <%= render_date(scheduling.start_date, @timezone) %>
                          -
                          <%= render_date(scheduling.end_date, @timezone) %>
                        </p>
                      </li>
                    <% end %>
                  </ol>
                <% end %>

              </section>
            <% end %>
          </div>

        </div>
      </div>
    </section>

    </div>

    """
  end
end
