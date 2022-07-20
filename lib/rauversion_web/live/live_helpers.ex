defmodule RauversionWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML.Form
  import RauversionWeb.ErrorHelpers

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
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to && !@close_handler do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% end %>

        <%= if @close_handler && !@return_to do %>
          <a id="close" href="#" phx-click={"close-modal"} phx-target={@close_handler} class="phx-modal-close">✖</a>
        <% end %>

        <%= if !@close_handler && !@return_to do %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()} class="phx-modal-close">✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
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
        <button type="button" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-orange-600 hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500">
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
          "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-orange-300 shadow-sm text-xs font-medium rounded text-orange-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500"
      }
    else
      %{
        class:
          "space-x-1 inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500"
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
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700" %>
        <div class="mt-1">
          <%= text_input @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-orange-500 focus:border-orange-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :date_input}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700" %>
        <div class="mt-1">
          <%= date_input @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-orange-500 focus:border-orange-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :select}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700" %>
        <div class="mt-1">
          <%= select @form, @field.name, @field.options, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-orange-500 focus:border-orange-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
        </div>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :date_select}) do
    assigns = LiveView.assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700" %>
        <div class="mt-1 flex space-x-1 items-center">
          <%= date_select @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-orange-500 focus:border-orange-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
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
            <%= radio_button(@form, @field.name, @field.value, class: "focus:ring-orange-500 h-4 w-4 text-orange-600 border-gray-300") %>
          </div>
          <div class="flex flex-col">
            <%= label @form, @field[:label] || @field.name, class: "block text-sm font-medium text-gray-700" %>
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
            <%= checkbox(@form, @field.name, class: "focus:ring-orange-500 h-4 w-4 text-orange-600 border-gray-300") %>
          </div>
          <div class="flex flex-col">
            <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700" %>
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
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700" %>
        <div class="mt-1">
          <%= textarea @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "max-w-lg shadow-sm block w-full focus:ring-orange-500 focus:border-orange-500 sm:text-sm border border-gray-300 rounded-md" %>
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
      "bg-orange-100 text-orange-700"
    else
      "text-orange-500 hover:text-orange-700"
    end
  end
end
