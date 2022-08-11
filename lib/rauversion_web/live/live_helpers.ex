defmodule RauversionWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML.Form
  import RauversionWeb.ErrorHelpers
  import RauversionWeb.Gettext

  alias Phoenix.LiveView.JS
  alias Phoenix.LiveView

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.track_index_path(@socket, :index)}>
        <.live_component
          module={RauversionWeb.TrackLive.FormComponent}
          id={@track.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.track_index_path(@socket, :index)}
          track: @track
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)
    assigns = assign_new(assigns, :close_handler, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale dark:bg-black dark:text-gray-100 border-4 border-white"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to && !@close_handler do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close dark:text-gray-100 dark:bg-gray-900",
            phx_click: hide_modal()
          %>
        <% end %>

        <%= if @close_handler && !@return_to do %>
          <a id="close" href="#" phx-click={"close-modal"} phx-target={@close_handler} class="phx-modal-close dark:text-gray-100">
            ✖
          </a>
        <% end %>

        <%= if !@close_handler && !@return_to do %>
          <a id="close" href="#" class="phx-modal-close dark:text-gray-100" phx-click={hide_modal()} class="phx-modal-close">
            ✖
          </a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def notification(assigns) do
    ~H"""
      <div aria-live="assertive" class="fixed inset-0 flex items-end px-4 py-6 pointer-events-none sm:p-6 sm:items-start">
        <div class="w-full flex flex-col items-center space-y-4 sm:items-end">
          <!--
            Notification panel, dynamically insert this into the live region when it needs to be displayed

            Entering: "transform ease-out duration-300 transition"
              From: "translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2"
              To: "translate-y-0 opacity-100 sm:translate-x-0"
            Leaving: "transition ease-in duration-100"
              From: "opacity-100"
              To: "opacity-0"
          -->
          <div class="max-w-sm w-full bg-white shadow-lg rounded-lg pointer-events-auto ring-1 ring-black ring-opacity-5 overflow-hidden">
            <div class="p-4">
              <div class="flex items-start">
                <div class="flex-shrink-0">
                  <!-- Heroicon name: outline/check-circle -->
                  <svg class="h-6 w-6 text-green-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div class="ml-3 w-0 flex-1 pt-0.5">
                  <p class="text-sm font-medium text-gray-900"><%= gettext "Successfully saved!" %></p>
                  <p class="mt-1 text-sm text-gray-500"><%= gettext "Anyone with a link can now view this file." %></p>
                </div>
                <div class="ml-4 flex-shrink-0 flex">
                  <button type="button" class="bg-white rounded-md inline-flex text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    <span class="sr-only"><%= gettext "Close" %></span>
                    <!-- Heroicon name: solid/x -->
                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                      <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    """
  end

  def empty_view(assigns) do
    ~H"""
    <div class="text-center">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
        <path vector-effect="non-scaling-stroke" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z" />
      </svg>
      <h3 class="mt-2 text-sm font-medium text-gray-900">No projects</h3>
      <p class="mt-1 text-sm text-gray-500">Get started by creating a new project.</p>
      <div class="mt-6">
        <button type="button" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500">
          <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
          </svg>
          New Project
        </button>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def active_button_class(struct) do
    if !is_nil(struct) do
      %{
        class:
          "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-700 shadow-sm text-xs font-medium rounded text-gray-700 bg-white dark:text-brand-300 dark:bg-black  hover:bg-brand-50 dark:hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500"
      }
    else
      %{
        class:
          "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 dark:border-gray-700 shadow-sm text-xs font-medium rounded text-gray-700 bg-white dark:text-gray-300 dark:bg-black  hover:bg-gray-50 dark:hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
      }
    end
  end

  def get_user_by_session(socket, session) do
    if session["user_token"] do
      user = Rauversion.Accounts.get_user_by_session_token(session["user_token"])

      socket
      |> assign(:current_user, user)
    else
      socket
      |> assign(:current_user, nil)
    end
  end

  def authorize_user_resource(socket, user_id) do
    if user_id == socket.assigns.current_user.id do
      {:ok, socket}
    else
      socket = socket |> put_flash(:error, "resource not authorized")
      {:err, push_patch(socket, to: "/", replace: true)}
    end
  end

  def live_audio_preview(%Phoenix.LiveView.UploadEntry{ref: ref} = entry, opts \\ []) do
    attrs =
      Keyword.merge(opts,
        id: opts[:id] || "phx-preview-#{ref}",
        data_phx_upload_ref: entry.upload_ref,
        data_phx_entry_ref: ref,
        data_phx_hook: "Phoenix.LiveImgPreview",
        data_phx_update: "ignore"
      )

    assigns = LiveView.assign(%{__changed__: nil}, attrs: attrs)

    ~H"""
      <audio controls>
        <source {@attrs}>
        Your browser does not support the audio tag.
      </audio>
    """
  end

  def form_input_renderer(f, field = %{type: :text_input}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= text_input @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:text-gray-100 dark:bg-gray-900 dark:text-gray-100" %>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :date_input}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= date_input @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :select}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= select @form, @field.name, @field.options, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :date_select}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1 flex space-x-1 items-center">
          <%= date_select @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :radio}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={"#{@field.wrapper_class}"}>
        <div class="flex items-center space-x-2 py-6">
          <div class="flex space-x-1 items-start">
            <%= radio_button(@form, @field.name, @field.value, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300") %>
          </div>
          <div class="flex flex-col">
            <%= label @form, @field[:label] || @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
            <p class="text-xs text-gray-500">
              <% #= Map.get(@form.data, @field.name) %>
              <%= case Map.get(@form.params, Atom.to_string(@field.name)) do
                "true" ->  Map.get(@field, :checked_hint) || Map.get(@field, :hint)
                "false" -> Map.get(@field, :unchecked_hint) || Map.get(@field, :hint)
                _ -> case Map.get(@form.data, @field.name) do
                  true ->  Map.get(@field, :checked_hint) || Map.get(@field, :hint)
                  false -> Map.get(@field, :unchecked_hint) || Map.get(@field, :hint)
                  _ -> Map.get(@field, :hint)
                end
              end
              %>
            </p>
          </div>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :checkbox}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={"#{@field.wrapper_class}"}>
        <div class="flex items-center space-x-2 py-6">
          <div class="flex space-x-1 items-start">
            <%= checkbox(@form, @field.name, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300") %>
          </div>
          <div class="flex flex-col">
            <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
            <p class="text-xs text-gray-500">
              <%= case Map.get(@form.params, Atom.to_string(@field.name)) do
                "true" ->  Map.get(@field, :checked_hint) || Map.get(@field, :hint)
                "false" -> Map.get(@field, :unchecked_hint) || Map.get(@field, :hint)
                _ -> case Map.get(@form.data, @field.name) do
                  true ->  Map.get(@field, :checked_hint) || Map.get(@field, :hint)
                  false -> Map.get(@field, :unchecked_hint) || Map.get(@field, :hint)
                  _ -> Map.get(@field, :checked_hint) || Map.get(@field, :hint)
                end
               end
               %>
            </p>
          </div>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :textarea}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= textarea @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "max-w-lg shadow-sm block w-full focus:ring-brand-500 focus:border-brand-500 sm:text-sm border border-gray-300 dark:border-gray-700 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= error_tag @form, @field.name %>
      </div>
    """
  end

  def render_attribution_fields(f) do
    assigns = LiveView.assign(%{__changed__: nil}, f: f)

    ~H"""
    <%= if Map.get(f.params, "copyright") == "common" || (Map.get(f.data, :copyright) == "common" && Map.get(f.params, "copyright") != "common") do %>
      <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-8">
        <%= for field <- Rauversion.Tracks.TrackMetadata.form_definitions("common") do %>
          <%= form_input_renderer(f, field) %>
        <% end %>
      </div>
    <% else %>

    <% end %>
    """
  end

  def active_tab_for?(current_tab, expected) do
    if current_tab == expected do
      "block"
    else
      "hidden"
    end
  end

  def active_tab_link?(current_tab, expected) do
    if current_tab == expected do
      "bg-brand-100 text-brand-700"
    else
      "text-brand-500 hover:text-brand-700"
    end
  end

  # used in live views
  def files_for(socket, kind) do
    case uploaded_entries(socket, kind) do
      {[_ | _] = entries, []} ->
        Enum.map(entries, fn entry ->
          consume_uploaded_entry(socket, entry, fn %{path: path} = _file ->
            {:postpone,
             %{
               path: path,
               content_type: entry.client_type,
               filename: entry.client_name,
               size: entry.client_size
             }}

            # dest = Path.join("priv/static/uploads", Path.basename(path))
            # File.cp!(path, dest)
            # Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
          end)
        end)

      _ ->
        []
    end
  end
end
