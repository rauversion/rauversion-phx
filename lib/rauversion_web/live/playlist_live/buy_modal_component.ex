defmodule RauversionWeb.PlaylistLive.BuyModalComponent do
  use RauversionWeb, :live_component

  @impl true
  def update(%{playlist: playlist} = assigns, socket) do
    changeset =
      Rauversion.Payments.Payment.change(
        %Rauversion.Payments.Payment{initial_price: playlist.metadata.price},
        %{}
      )

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:buy_modal, false)
     |> assign(:include_message, false)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("open-modal", %{}, socket) do
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
  def handle_event("validate", %{"payment" => payment_params}, socket) do
    changeset =
      socket.assigns.changeset.data
      |> Rauversion.Payments.Payment.change(payment_params)
      |> Map.put(:action, :validate)

    IO.inspect(changeset.data)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{}, socket) do
    IO.inspect("CHECKOUT")
    a = create_stripe_session(%{}, socket.assigns.playlist)
    IO.inspect(a)

    with {:ok, %{"url" => url} = _data} <- a do
      {:noreply,
       socket
       |> redirect(external: url)}
    else
      _ ->
        {:noreply, socket}
    end
  end

  def create_stripe_session(_order, album) do
    client = Rauversion.Stripe.Client.new()
    user = album |> Ecto.assoc(:user) |> Rauversion.Repo.one()

    c = Rauversion.Accounts.get_oauth_credential(user, "stripe")

    line_items =
      [%{}]
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {x, i}, acc ->
        acc
        |> Map.merge(%{
          "#{i}" => %{
            "quantity" => 1,
            "price_data" => %{
              "unit_amount" => Decimal.to_integer(album.metadata.price) * 100,
              "currency" => "USD",
              "product_data" => %{
                "name" => album.title,
                "description" => "short_description"
              }
            }
          }
        })
      end)

    IO.inspect(line_items)

    # total =
    #  Rauversion.PurchaseOrders.calculate_total(order, event.events_settings.ticket_currency)

    # fee_amount =
    #  Rauversion.PurchaseOrders.calculate_fee(total, event.events_settings.ticket_currency)

    Rauversion.Stripe.Client.create_session(
      client,
      c.uid,
      %{
        "line_items" => line_items,
        "payment_intent_data" => %{
          "application_fee_amount" => 100
          # "transfer_data"=> %{
          #  "destination"=> c.uid
          # }
        },
        "mode" => "payment",
        "success_url" =>
          RauversionWeb.Router.Helpers.events_show_url(
            RauversionWeb.Endpoint,
            :payment_success,
            album.slug
          ),
        "cancel_url" =>
          RauversionWeb.Router.Helpers.events_show_url(
            RauversionWeb.Endpoint,
            :payment_cancel,
            album.slug
          )
      }
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div>
      <%= if @buy_modal do %>
        <.modal close_handler={@myself}>
          <div class="flex flex-col">
            <.form
              let={f}
              for={@changeset}
              id="edit-playlist-form"
              class="space-y-4"
              phx-target={@myself}
              phx-change="validate"
              phx-submit="save">

              <span class="text-xl py-4">
                <%= gettext("Buy Digital album") %>
              </span>

              <div class="col-span-3 sm:col-span-2">
                <label for="company-website" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  <%= gettext("Price") %>
                </label>

                <%= if @playlist.metadata.name_your_price do %>
                  <div class="mt-1 flex rounded-md shadow-sm">
                    <span class="inline-flex items-center rounded-l-md border border-r-0 border-gray-300 dark:bg-gray-900 dark:border-gray-800 bg-gray-50 px-3 text-sm text-gray-500 dark:text-white">
                      $
                    </span>
                    <%= text_input f, :price,
                      class: "block w-64 flex-1- rounded-none rounded-r-md border-gray-300 dark:border-gray-800 dark:bg-gray-800 focus:border-brand-500 focus:ring-brand-500 sm:text-sm",
                      placeholder: gettext("Name your price %{num} or more", num: Number.Currency.number_to_currency(@playlist.metadata.price, precision: 2) )
                    %>
                  </div>
                  <%= error_tag f, :price %>

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
                <%= if Ecto.Changeset.get_field(@changeset, :include_message) do %>
                  <div class="mt-1">
                    <%= textarea f, :optional_message,
                      class: "mt-1 block w-full rounded-md border-gray-300 dark:text.gray-600 dark:bg-gray-800 text-gray-100 shadow-sm focus:border-brand-500 focus:ring-brand-500 sm:text-sm",
                      placeholder: "optional message",
                      rows: 3
                    %>
                    <%= error_tag f, :optional_message %>
                  </div>
                <% end %>

                <p class="mt-2 text-sm text-gray-500">
                  <label class="hover:underline space-x-2 flex items-center">
                    <%= checkbox f, :include_message %>
                    <span>
                      <%= gettext("include a message to %{name}", name: "foo") %>
                    </span>
                  </label>
                </p>
              </div>

              <%= submit gettext("Checkout"),
                phx_disable_with: "Saving...",
                class: "mt-4 py-4 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500"
              %>

            </.form>
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
