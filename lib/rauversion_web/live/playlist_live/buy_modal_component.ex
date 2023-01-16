defmodule RauversionWeb.PlaylistLive.BuyModalComponent do
  use RauversionWeb, :live_component

  @impl true
  def update(%{playlist: _playlist} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:buy_modal, false)
     |> assign(:include_message, false)}
  end

  @impl true
  def handle_event("open-modal", %{}, socket) do
    {:noreply,
     socket
     |> assign(:buy_modal, true)}
  end

  @impl true
  def handle_event("include_message", %{}, socket) do
    {:noreply,
     socket
     |> assign(:include_message, !socket.assigns.include_message)}
  end

  @impl true
  def handle_event("close-modal", %{}, socket) do
    {:noreply,
     socket
     |> assign(:buy_modal, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div>
      <%= if @buy_modal do %>
        <.modal close_handler={@myself}>
          <div class="flex flex-col">

            <span class="text-xl py-4"><%= gettext("Buy Digital album") %></span>

            <div class="col-span-3 sm:col-span-2">
              <label for="company-website" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                <%= gettext("Price") %>
              </label>

              <%= if @playlist.metadata.name_your_price do %>
                <div class="mt-1 flex rounded-md shadow-sm">
                  <span class="inline-flex items-center rounded-l-md border border-r-0 border-gray-300 dark:bg-gray-900 dark:border-gray-800 bg-gray-50 px-3 text-sm text-gray-500 dark:text-white">
                    $
                  </span>
                  <input type="text"
                    name="company-website"
                    id="company-website"
                    class="block w-64 flex-1- rounded-none rounded-r-md border-gray-300 dark:border-gray-800 dark:bg-gray-800 focus:border-brand-500 focus:ring-brand-500 sm:text-sm"
                    placeholder={gettext("Name your price %{num} or more", num: Number.Currency.number_to_currency(@playlist.metadata.price, precision: 2) )}>
                </div>
              <% else %>

                <div class="text-xl">
                  <%= Number.Currency.number_to_currency(@playlist.metadata.price, precision: 2) %>
                </div>
              <% end %>
            </div>

            <span class="py-4 text-sm">
              <%= gettext("Includes unlimited streaming via the %{app_name} app, plus high-quality download in MP3, FLAC", app_name: Application.get_env(:rauversion, :app_name, "rauversion.com") ) %>
            </span>

            <div>

              <%= if @include_message do %>
                <div class="mt-1">
                  <textarea id="about" name="about" rows="3"
                    class="mt-1 block w-full rounded-md border-gray-300 dark:text.gray-600 dark:bg-gray-800 text-gray-100 shadow-sm focus:border-brand-500 focus:ring-brand-500 sm:text-sm" placeholder="you@example.com"></textarea>
                </div>
              <% end %>

              <p class="mt-2 text-sm text-gray-500">
                <button phx-click="include_message" phx-target={@myself} class="hover:underline">
                  <%= gettext("include a message to %{name}", name: "foo") %>
                </button>
              </p>
            </div>

            <button class="mt-4 py-4 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500">
              <%= gettext("Go to checkout") %>
            </button>


          </div>
        </.modal>
      <% end %>


      <%= if @playlist.metadata && @playlist.metadata.price do %>
          <div class="text-2xl font-bold">
            <button class="underline" target="blank" phx-click="open-modal" phx-target={@myself}>
              <%= gettext("Buy Digital Album") %>
            </button>

            <span>
              <%= Number.Currency.number_to_currency(@playlist.metadata.price, precision: 2) %>
              <span class="text-sm text-gray-300">
                USD
              </span>
            </span>

            <%= if @playlist.metadata.name_your_price do %>
              <span class="text-sm text-gray-300">
                <%= gettext("or more") %>
              </span>
            <% end %>
          </div>
        <% end %>

      </div>
    """
  end
end
