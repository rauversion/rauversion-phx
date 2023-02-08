defmodule RauversionWeb.BlockedView do
  use RauversionWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-gray-900 h-screen">
      <div class="mx-auto max-w-2xl py-16 px-4 text-center sm:py-20 sm:px-6 lg:px-8">
        <h2 class="text-3xl font-bold tracking-tight text-white sm:text-4xl">
          <span class="block">
            <%= @title %>
          </span>
          <span class="block text-2xl">
            <%= @subtitle %>
          </span>
        </h2>
        <p class="mt-4 text-lg leading-6 text-brand-200">
          <%= @description %>
        </p>
        <a
          href="mailto:info@rauversion.com"
          class="mt-8 inline-flex w-full items-center justify-center rounded-md border border-transparent bg-white px-5 py-3 text-base font-medium text-brand-600 hover:bg-brand-50 sm:w-auto"
        >
          <%= @cta %>
        </a>
      </div>
    </div>
    """
  end
end
