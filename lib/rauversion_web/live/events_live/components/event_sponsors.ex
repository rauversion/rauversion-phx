defmodule RauversionWeb.EventsLive.EventSponsors do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <section id="sponsors" aria-label="Sponsors" class="py-20 sm:py-32">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <h2 class="mx-auto max-w-2xl text-center font-display text-4xl font-medium tracking-tighter text-brand-900 sm:text-5xl">Current sponsorships for our workshops and speakers.</h2>
        <div class="mx-auto mt-20 grid max-w-max grid-cols-1 place-content-center gap-y-12 gap-x-32 sm:grid-cols-3 md:gap-x-16 lg:gap-x-32">
          <div class="flex items-center justify-center">
            <img alt="Transistor" src="/_next/static/media/transistor.a1e38d49.svg" width="158" height="48" decoding="async" data-nimg="future" loading="lazy">
          </div>
          <div class="flex items-center justify-center">
            <img alt="Tuple" src="/_next/static/media/tuple.2f54ed03.svg" width="105" height="48" decoding="async" data-nimg="future" loading="lazy">
          </div>
          <div class="flex items-center justify-center">
            <img alt="StaticKit" src="/_next/static/media/statickit.2e06fcea.svg" width="127" height="48" decoding="async" data-nimg="future" loading="lazy">
          </div>
          <div class="flex items-center justify-center">
            <img alt="Mirage" src="/_next/static/media/mirage.e12f40ad.svg" width="138" height="48" decoding="async" data-nimg="future" loading="lazy">
          </div>
          <div class="flex items-center justify-center">
            <img alt="Laravel" src="/_next/static/media/laravel.6faebf7c.svg" width="136" height="48" decoding="async" data-nimg="future" loading="lazy">
          </div>
          <div class="flex items-center justify-center">
            <img alt="Statamic" src="/_next/static/media/statamic.923101b6.svg" width="147" height="48" decoding="async" data-nimg="future" loading="lazy">
          </div>
        </div>
      </div>
    </section>
    """
  end
end
