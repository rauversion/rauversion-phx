defmodule RauversionWeb.Live.EventsLive.Components.EventOverview do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>

      <div class="bg-gray-50- dark:bg-gray-900- pt-12 sm:pt-16">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div class="mx-auto max-w-4xl text-center">
            <h2 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl">
              Event overview
            </h2>
            <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 dark:text-gray-300 dark:text-gray-300 sm:mt-4">
              Lorem ipsum dolor, sit amet consectetur adipisicing elit. Repellendus repellat laudantium.
            </p>
          </div>
        </div>
        <div class="mt-10 bg-white dark:bg-black pb-12 sm:pb-16">
          <div class="relative">
            <div class="absolute inset-0 h-1/2 bg-gray-50--"></div>
            <div class="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
              <div class="mx-auto max-w-4xl">
                <dl class="rounded-lg bg-white dark:bg-black border shadow-lg sm:grid sm:grid-cols-3">
                  <div class="flex flex-col border-b border-gray-100 dark:border-gray-900 p-6 text-center sm:border-0 sm:border-r">
                    <dt class="order-2 mt-2 text-lg font-medium leading-6 text-gray-500 dark:text-gray-300 dark:text-gray-300">
                      <%= gettext("Tickets sales") %>
                    </dt>
                    <dd class="order-1 text-5xl font-bold tracking-tight text-brand-600 dark:text-brand-400">
                      $0.00
                    </dd>
                  </div>
                  <div class="flex flex-col border-t border-b border-gray-100 dark:border-gray-900 p-6 text-center sm:border-0 sm:border-l sm:border-r">
                    <dt class="order-2 mt-2 text-lg font-medium leading-6 text-gray-500 dark:text-gray-300 dark:text-gray-300">
                      <%= gettext("Tickets sold") %>
                    </dt>
                    <dd class="order-1 text-5xl font-bold tracking-tight text-brand-600 dark:text-brand-400">
                      <%= Rauversion.Events.purchased_tickets_count(@event) %>
                    </dd>
                  </div>
                  <div class="flex flex-col border-t border-gray-100 dark:border-gray-900 p-6 text-center sm:border-0 sm:border-l">
                    <dt class="order-2 mt-2 text-lg font-medium leading-6 text-gray-500 dark:text-gray-300 dark:text-gray-300">
                      <%= gettext("Page visitors") %>
                    </dt>
                    <dd class="order-1 text-5xl font-bold tracking-tight text-brand-600 dark:text-brand-400">
                      0
                    </dd>
                  </div>
                </dl>
              </div>
            </div>
          </div>
        </div>
      </div>


    </div>
    """
  end
end
