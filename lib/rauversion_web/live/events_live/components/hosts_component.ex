defmodule RauversionWeb.Live.EventsLive.Components.HostsComponent do
  use RauversionWeb, :live_component

  alias Rauversion.{Events, Accounts, EventHosts}

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:action, nil)
     |> assign(hosts: get_hosts(assigns.event))
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)
     |> assign(:modal, nil)}
  end

  # nono
  @impl true
  def handle_event("add-host", _, socket) do
    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.append_at(:event_hosts, %{})
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("upload-modal", %{"index" => id}, socket) do
    {:noreply,
     socket
     |> assign(:modal, true)
     |> assign(:host, find_host(socket.assigns.event, id))}
  end

  @impl true
  def handle_event("close-modal", %{}, socket) do
    {:noreply,
     assign(socket, :modal, nil)
     |> assign(:new_modal, nil)}
  end

  @impl true
  def handle_event(
        "delete-host",
        %{"index" => index},
        socket
      ) do
    # index = String.to_integer(index)

    case Events.get_host!(socket.assigns.event, index) do
      %EventHosts.EventHost{} = host ->
        if socket.assigns.event.user_id == host.user_id do
          {:noreply,
           assign(socket, :modal, false)
           |> assign(:hosts, get_hosts(socket.assigns.event))
           |> put_flash(:info, "Host creator can't be removed")}
        else
          EventHosts.delete_event_host(host)

          {:noreply,
           assign(socket, :modal, false)
           |> assign(:hosts, get_hosts(socket.assigns.event))}
        end

      _ ->
        nil
    end

    # socket =
    #  update(socket, :changeset, fn changeset ->
    #    changeset
    #    |> Ecto.Changeset.apply_changes()
    #    |> Ecto.Changeset.change()
    #    |> EctoNestedChangeset.delete_at([
    #      :event_hosts,
    #      index
    #    ])
    #  end)

    # {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"user" => event_params}, socket) do
    changeset =
      Accounts.change_user_invitation(%Accounts.User{}, event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"event_host" => event_params}, socket) do
    changeset =
      EventHosts.change_event_host(socket.assigns.changeset.data, event_params)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  # @impl true
  # def handle_event("validate", _, socket) do
  #  handle_event("validate", %{"event" => %{"event_hosts" => []}}, socket)
  # end

  @impl true
  def handle_event("save", %{"user" => event_params}, socket) do
    save_user_invite(socket, :edit, event_params)
  end

  @impl true
  def handle_event("save", %{"event_host" => event_params}, socket) do
    save_event_host(socket, :edit, event_params)
  end

  @impl true
  def handle_event("new-host", _, socket) do
    changeset = Accounts.change_user_invitation(%Accounts.User{})

    {
      :noreply,
      assign(socket, :modal, true)
      |> assign(:changeset, changeset)
      |> assign(:action, :new_host)
    }
  end

  @impl true
  def handle_event("edit-host", %{"host-id" => id}, socket) do
    host = Events.get_host!(socket.assigns.event, id)
    changeset = EventHosts.change_event_host(host)

    {
      :noreply,
      assign(socket, :modal, true)
      |> assign(:changeset, changeset)
      |> assign(:action, :edit_host)
    }
  end

  def find_host(event, id) do
    Rauversion.Events.get_host!(event, id)
  end

  defp save_user_invite(socket, :edit, %{"email" => email}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        case Accounts.invite_user(%Accounts.User{}, %{email: email}) do
          {:ok, user} ->
            {:ok, _} =
              Accounts.deliver_user_invitation_instructions(
                user,
                &Routes.user_invitation_url(socket, :accept, &1)
              )

            host =
              Rauversion.EventHosts.create_event_host(%{
                name: "-",
                user_id: user.id,
                event_id: socket.assigns.event.id
              })

            {:noreply,
             assign(socket, :modal, nil)
             |> assign(:hosts, get_hosts(socket.assigns.event))
             |> put_flash(:info, "Hosts added successfully")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      user ->
        Rauversion.EventHosts.create_event_host(%{
          name: "-",
          user_id: user.id,
          event_id: socket.assigns.event.id
        })

        {:noreply,
         assign(socket, :modal, nil)
         |> assign(:hosts, get_hosts(socket.assigns.event))
         |> put_flash(:info, "Hosts added successfully")}
    end
  end

  # defp save_event(socket, :edit, %{"event" => event_params}) do
  #  case Rauversion.Events.update_event(socket.assigns.event, event_params) do
  #    {:ok, _event} ->
  #      {
  #        :noreply,
  #        socket
  #        |> put_flash(:info, "Hosts updated successfully")
  #        # |> push_redirect(to: socket.assigns.return_to)
  #      }

  #    {:error, %Ecto.Changeset{} = changeset} ->
  #      {:noreply, assign(socket, :changeset, changeset)}
  #  end
  # end

  defp save_event_host(socket, :edit, event_params) do
    event_params =
      event_params
      |> Map.put("avatar", files_for(socket, :avatar))

    case EventHosts.update_event_host(socket.assigns.changeset.data, event_params) do
      {:ok, _event} ->
        {
          :noreply,
          socket
          |> assign(:modal, nil)
          |> assign(:hosts, get_hosts(socket.assigns.event))
          |> put_flash(:info, "Host updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  # defp save_event(socket, :edit, %{}) do
  #  save_event(socket, :edit, %{"event" => %{"event_hosts" => []}})
  # end

  def get_hosts(event) do
    Rauversion.Events.get_hosts(event)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-5 w-full">

        <%= if @modal do %>
          <%= if @action == :new_host do %>
            <.modal close_handler={@myself} w_class={"w-1/4"}>
              <.form
                let={f}
                for={@changeset}
                phx-target={@myself}
                id="hosts-form"
                phx-change="validate"
                phx-submit="save">
                <div class="space-y-3">
                  <%= gettext("Add a host to highlight them on the event page or to get help managing the event.") %>
                  <%= form_input_renderer(f, %{type: :text_input, name: :email, wrapper_class: "", placeholder: "email"}) %>
                  <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
                </div>
              </.form>
            </.modal>
          <% end %>


          <%= if @action == :edit_host do %>
            <.modal close_handler={@myself} w_class={"w-2/4"}>

              <.form
                let={i}
                for={@changeset}
                phx-target={@myself}
                id="playlist-form"
                phx-change="validate"
                phx-submit="save">

                <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                  <div class="sm:col-span-6">

                      <div class="sm:col-span-6">
                        <%= form_input_renderer(i, %{
                          type: :upload,
                          uploads: @uploads,
                          name: :avatar
                          }) %>
                      </div>

                        <%= form_input_renderer(i, %{
                          type: :text_input,
                          name: :name,
                          wrapper_class: "sm:col-span-3",
                          hint: gettext("Host Name")
                        }) %>

                        <%= form_input_renderer(i, %{
                          type: :textarea,
                          name: :description,
                          wrapper_class: "sm:col-span-6",
                          hint: gettext("Host description.")
                        }) %>

                        <%= form_input_renderer(i, %{
                          type: :checkbox,
                          name: :listed_on_page,
                          wrapper_class: "sm:col-span-4",
                          label: "Listed on page",
                          hint: gettext("if checked Host will be listed on Event's page.")
                        }) %>

                        <%= form_input_renderer(i, %{
                          type: :checkbox,
                          name: :event_manager,
                          wrapper_class: "sm:col-span-4",
                          label: "Manager",
                          hint: gettext("if checked the Host will have manager access to event.")
                        }) %>

                      </div>

                  <div class="sm:col-span-6 flex justify-end space-x-2">
                    <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
                  </div>

                </div>

              </.form>

            </.modal>
          <% end %>
        <% end %>

        <h2 class="mx-0 mt-0 mb-4 font-sans text-2xl font-bold leading-none">
          <%= gettext "Host & Managers" %>
        </h2>

        <button type="button"
          phx-click="new-host"
          phx-target={@myself}
          class="mt-2 inline-flex justify-center items-center border-2 border-white-600 rounded-lg py-2 px-2 dark:bg-black text-white-600 block text-sm"
          >
          <%= gettext("New host") %>
        </button>

        <ul role="list" class="mt-4 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <%= for host <- @hosts do %>
            <li class="col-span-1 divide-y divide-gray-200 dark:divide-gray-800 rounded-lg bg-white dark:bg-gray-900 shadow">
              <div class="flex w-full items-center justify-between space-x-6 p-6">
                <div class="flex-1 truncate">
                  <div class="flex flex-col items-start space-x-3 justify-center">
                    <div class="flex justify-between">
                      <h3 class="truncate text-sm font-medium text-gray-900 dark:text-gray-100">
                        <%= host.name %>
                        <%= if host.user do %>
                          user: <%= host.user.username %>
                        <% end %>
                      </h3>

                      <%= if host.event_manager do %>
                        <span class="inline-block flex-shrink-0 rounded-full bg-green-100 dark:bg-green-900 px-2 py-0.5 text-xs font-medium text-green-800 dark:text-green-200">
                          Admin
                        </span>
                      <% end %>
                    </div>

                    <div class="sm:col-span-6">

                      <button type="button"
                        phx-click="edit-host"
                        phx-value-host-id={host.id}
                        phx-target={@myself}
                        class="mt-2 inline-flex justify-center items-center text-white-600 block text-xs">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
                        </svg>
                      </button>

                      <button type="button"
                        phx-click="delete-host"
                        phx-target={@myself}
                        class="mt-2 inline-flex justify-center items-center text-white-600 block text-xs"
                        phx-value-index={host.id}>
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
                        </svg>
                      </button>

                    </div>


                  </div>
                  <p class="mt-1 truncate text-sm text-gray-500 dark:text-gray-400">
                    <%= host.description %>
                  </p>
                </div>
                <img class="h-10 w-10 flex-shrink-0 rounded-full bg-gray-300 dark:bg-gray-700"
                    src={Rauversion.BlobUtils.variant_url(host, :avatar,
                    %{resize_to_limit: "100x100"}, fn ()->
                    Rauversion.BlobUtils.variant_url(host.user, :avatar)
                    end)}
                >
              </div>

            </li>
          <% end %>
        </ul>


      </div>
    """
  end
end
