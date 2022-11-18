defmodule RauversionWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.Component
  import Phoenix.HTML.Form
  import RauversionWeb.ErrorHelpers
  import RauversionWeb.Gettext
  import Phoenix.HTML.Tag

  alias Phoenix.LiveView.JS
  # alias Phoenix.LiveView

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
    assigns = assign_new(assigns, :w_class, fn -> "w-3/4" end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class={"phx-modal-content #{@w_class} fade-in-scale bg-white text-gray-900 dark:bg-black dark:text-gray-100 border-2 border-black dark:border-white"}
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

    assigns = assign(%{__changed__: nil}, attrs: attrs)

    ~H"""
      <audio controls>
        <source {@attrs}>
        Your browser does not support the audio tag.
      </audio>
    """
  end

  def form_input_renderer(f, field = %{type: :text_input}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1"
          phx-update={ if Map.get(@field,:hook), do: "ignore"}
          id={if @field[:id], do: "ww-#{@field.id}"}>
          <%= text_input @form, @field.name,
            placeholder: Map.get(@field, :placeholder),
            phx_hook: Map.get(@field,:hook),
            class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= if get_in(assigns.field, [:hint]) do %>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            <%= assigns.field.hint %>
          </p>
        <% end %>
        <%= error_tag @form, @field.name %>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :number_input}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= number_input @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= if get_in(assigns.field, [:hint]) do %>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            <%= assigns.field.hint %>
          </p>
        <% end %>
        <%= error_tag @form, @field.name %>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :date_input}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= date_input @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= if get_in(assigns.field, [:hint]) do %>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            <%= assigns.field.hint %>
          </p>
        <% end %>
        <%= error_tag @form, @field.name %>

      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :datetime_input}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= datetime_local_input @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= if get_in(assigns.field, [:hint]) do %>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            <%= assigns.field.hint %>
          </p>
        <% end %>
        <%= error_tag @form, @field.name %>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :select}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= select @form, @field.name, @field.options, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= if get_in(assigns.field, [:hint]) do %>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            <%= assigns.field.hint %>
          </p>

        <% end %>
        <%= error_tag @form, @field.name %>

      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :date_select}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1 flex space-x-1 items-center">
          <%= date_select @form, @field.name, placeholder: Map.get(@field, :placeholder), class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= if get_in(assigns.field, [:hint]) do %>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            <%= assigns.field.hint %>
          </p>
        <% end %>
        <%= error_tag @form, @field.name %>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :radio}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={"#{@field.wrapper_class}"}>
        <div class="flex items-center space-x-2 py-2">
          <div class="flex space-x-1 items-start">
            <%= radio_button(@form, @field.name, @field.value, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300") %>
          </div>
          <div class="flex flex-col">
            <%= label @form, @field[:label] || @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
            <p class="text-xs text-gray-500 dark:text-gray-300">
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
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={"#{@field.wrapper_class}"}>
        <div class="flex items-center space-x-2 py-2">
          <div class="flex space-x-1 items-start">
            <%= checkbox(@form, @field.name, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300") %>
          </div>
          <div class="flex flex-col">
            <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
            <p class="text-xs text-gray-500 dark:text-gray-300">
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
    assigns = assign(%{__changed__: nil}, field: field, form: f)

    ~H"""
      <div class={@field.wrapper_class}>
        <%= label @form, @field.name, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
        <div class="mt-1">
          <%= textarea @form, @field.name, placeholder: Map.get(@field, :placeholder),
          class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100" %>
        </div>
        <%= if get_in(assigns.field, [:hint]) do %>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
            <%= assigns.field.hint %>
          </p>
        <% end %>
        <%= error_tag @form, @field.name %>
      </div>
    """
  end

  def form_input_renderer(f, field = %{type: :upload, name: name}) do
    assigns = assign(%{__changed__: nil}, field: field, form: f, name: name)

    ~H"""

    <div class="sm:grid sm:grid-cols-1 sm:gap-4 sm:items-start sm:border-gray-200 sm:pt-5">
      <label for="cover-photo" class="block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2">
        <%= @field[:label] || gettext( "Cover photo") %>
      </label>

      <div class="mt-1 sm:mt-0 sm:col-span-2">
        <div class="max-w-lg flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 dark:border-gray-600 border-dashed rounded-md"
          phx-drop-target={@field.uploads[@name].ref}>
          <div class="space-y-1 text-center">


            <%= if Rauversion.BlobUtils.blob_for(@form.data, "#{@name}") == nil do %>

              <svg class="mx-auto h-12 w-12 text-gray-400 dark:text-gray-100" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
              </svg>

            <% else %>

              <%= img_tag(Rauversion.BlobUtils.variant_url( @form.data, "#{@name}"), class: "object-center object-cover group-hover:opacity-75") %>

            <% end %>

            <div class="flex text-sm text-gray-600 dark:text-gray-400 py-3">
              <label class="relative cursor-pointer rounded-md font-medium text-brand-600 hover:text-brand-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-brand-500">
                <span>
                  <%= gettext( "Upload a %{subject}", %{subject: @field[:label] || "Track" }) %>
                </span>
                <% #= form.file_field :audio, direct_upload: true, id: "file-audio-upload", class: "sr-only" %>
                <.live_file_input upload={@field.uploads[@name]} class="hidden" />
                <% #= live_file_input @field.uploads[name], class: "hidden" %>
              </label>
              <p class="pl-1">
                <%= gettext "or drag and drop" %>
              </p>
            </div>

            <div>
              <%= for entry <- @field.uploads[@name].entries do %>
                <div class="flex items-center space-x-2">
                  <.live_img_preview entry={entry} width={300} />
                  <div class="text-xl font-bold">
                    <%= entry.progress %>%
                  </div>
                </div>
              <% end  %>

              <%= for {_ref, msg, } <- @field.uploads[@name].errors do %>
                <%= Phoenix.Naming.humanize(msg) %>
              <% end %>
            </div>

            <p class="text-xs text-gray-500 dark:text-gray-300">
              <%= @field[:permitted_extensions_label] || gettext("PNG, JPG, GIF up to 10MB") %>
            </p>
          </div>
        </div>
      </div>
    </div>

    """
  end

  def locale_list do
    now = DateTime.utc_now()

    Tzdata.zone_list()
    |> Enum.map(fn zone ->
      tzinfo = Timex.Timezone.get(zone, now)
      # added in v3.78
      # _offset = Timex.TimezoneInfo.format_offset(tzinfo)
      # _label = "#{tzinfo.full_name} - #{tzinfo.abbreviation} (#{offset})"

      # {tzinfo.full_name, label}
      {tzinfo.full_name, tzinfo.full_name}
    end)
    |> Enum.uniq()
  end

  def render_attribution_fields(f) do
    assigns = assign(%{__changed__: nil}, f: f)

    ~H"""
    <%= if Map.get(@f.params, "copyright") == "common" || (Map.get(@f.data, :copyright) == "common" && Map.get(@f.params, "copyright") != "common") do %>
      <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-8">
        <%= for field <- Rauversion.Tracks.TrackMetadata.form_definitions("common") do %>
          <%= form_input_renderer(@f, field) %>
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

  def is_creator?(current_user) do
    case current_user.type do
      "user" -> false
      nil -> false
      _ -> true
    end
  end

  def is_admin?(current_user) do
    case current_user.type do
      "admin" -> true
      _ -> false
    end
  end

  def simple_date_for(date, format \\ :long) do
    case Cldr.Date.to_string(date, format: format) do
      {:ok, d} -> d
      _ -> date
    end
  end
end
