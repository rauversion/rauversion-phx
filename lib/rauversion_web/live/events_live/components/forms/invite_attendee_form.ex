defmodule RauversionWeb.EventsLive.Components.Forms.InviteAttendeeForm do
  use RauversionWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:tickets, get_tickets(assigns.event))

    {:ok, socket}
  end

  def get_tickets(event) do
    event |> Rauversion.Events.public_event_tickets()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="sm:flex sm:items-center">
        <div class="sm:flex-auto mb-4">
          <h1 class="text-xl font-semibold text-gray-900 dark:text-gray-100">
            <%= gettext("Send invitations") %>
          </h1>
          <p class="mt-2 text-sm text-gray-700 dark:text-gray-300"><%= gettext("Give away courtesy invitations.") %></p>
        </div>
      </div>
      <.form
        let={f}
        for={@changeset}
        id="events-form"
        phx-change="validate"
        phx-target={@target}
        phx-submit="save"
        class="space-y-2"
        >

        <%= error_tag f, :not_valid %>

        <%= form_input_renderer(f, %{
          type: :text_input,
          name: :email,
          wrapper_class: "sm:col-span-2",
          label: "Email address",
          hint: "Add a valid email address"
        }) %>

        <%= form_input_renderer(f, %{
          label: "Ticket",
          type: :select,
          options: Enum.map(@tickets, fn t -> {t.title, t.id} end),
          wrapper_class: nil,
          name: :ticket_id })
        %>

        <%= form_input_renderer(f, %{
          type: :textarea,
          name: :message,
          wrapper_class: "sm:col-span-2",
          label: "Message",
          hint: "Add an optional message"
        }) %>



        <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>

      </.form>
    </div>
    """
  end
end
