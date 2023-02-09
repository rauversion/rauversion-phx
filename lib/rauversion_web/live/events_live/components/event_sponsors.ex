defmodule RauversionWeb.EventsLive.EventSponsors do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <section id="sponsors" aria-label="Sponsors" class="py-20 sm:py-32">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <h2 class="mx-auto max-w-2xl text-center font-display text-4xl font-medium tracking-tighter text-brand-900 dark:text-brand-100 sm:text-5xl">
          <%= @event.event_settings.sponsors_description %>
        </h2>
        <div class="mx-auto mt-20 grid max-w-max grid-cols-1 place-content-center gap-y-12 gap-x-32 sm:grid-cols-3 md:gap-x-16 lg:gap-x-32">
          <div class="flex items-center justify-center">
            <img
              alt="MMM"
              src="###"
              width="105"
              height="48"
              decoding="async"
              data-nimg="future"
              loading="lazy"
            />
          </div>
        </div>
      </div>
    </section>
    """
  end
end
