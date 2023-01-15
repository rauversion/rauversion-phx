defmodule RauversionWeb.PlaylistLive.BuyModalComponent do
  use RauversionWeb, :live_component

  def update(%{playlist: _playlist} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:buy_modal, false)}
  end

  @impl true
  def handle_event("buy-modal", %{}, socket) do
    {:noreply,
     socket
     |> assign(:buy_modal, true)}
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
          <div>alo alo</div>
        </.modal>
      <% end %>



      <%= if @playlist.metadata && @playlist.metadata.price do %>
          <div class="text-2xl font-bold">
            <button class="underline" target="blank" phx-click="buy-modal" phx-target={@myself}>
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
