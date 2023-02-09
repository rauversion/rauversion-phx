defmodule RauversionWeb.TrackLive.UploadFormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(
        %{
          uploads: _uploads,
          target: _target,
          track: _track,
          current_user: _current_user,
          changeset: _changeset
        } = assigns
      ) do
    ~H"""
    <div>
      <.form
        :let={f}
        for={@changeset}
        id="track-form-2"
        phx-target={@target}
        phx-change="validate"
        phx-submit="save"
        multipart={true}
        class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
      >
        <div class="mt-6 sm:mt-5 space-y-6 sm:space-y-5 flex justify-center">
          <div class="flex-col">
            <div class="text-center">
              <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                <%= gettext("Drag and drop your tracks & albums here") %>
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                <%= gettext("Provide FLAC, WAV, ALAC, or AIFF for highest audio quality.") %>
              </p>
            </div>

            <div class="mt-6 sm:mt-5 space-y-6 sm:space-y-5" phx-drop-target={@uploads.audio.ref}>
              <div class="flex-col">
                <div class="mt-1 sm:mt-0 sm:col-span-2">
                  <div class="max-w-lg flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 dark:border-gray-700 border-dashed rounded-md">
                    <div class="space-y-1 text-center">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        class="mx-auto h-12 w-12 text-gray-400"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                        stroke-width="2"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"
                        />
                      </svg>
                      <% # = @track.audio&.filename if @track.audio.persisted? %>
                      <div class="flex text-sm text-gray-600 text-gray-300 py-3">
                        <label class="relative cursor-pointer rounded-md font-medium text-brand-600 hover:text-brand-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-brand-500">
                          <span><%= gettext("Upload a Audio file") %></span>
                          <.live_file_input upload={@uploads.audio} class="hidden" />
                          <% # = live_file_input @uploads.audio, class: "hidden" %>
                        </label>
                        <p class="pl-1"><%= gettext("or drag and drop") %></p>
                      </div>

                      <div>
                        <%= for entry <- @uploads.audio.entries do %>
                          <div class="flex items-center space-x-2">
                            <%= live_audio_preview(entry, height: 80) %>
                            <div class="text-xl font-bold">
                              <%= entry.progress %>%
                            </div>
                          </div>
                        <% end %>

                        <%= for {_ref, msg, } <- @uploads.audio.errors do %>
                          <%= Phoenix.Naming.humanize(msg) %>
                        <% end %>
                      </div>

                      <p class="text-xs text-gray-500">
                        <%= gettext("Audio, up to 200MB") %>
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="flex items-center space-x-2 text-sm text-gray-600 text-gray-300 my-2">
              <%= label(f, :private, "Privacy:") %>
              <%= label(f, :private, "Private") %>
              <%= radio_button(f, :private, true) %>
              <%= label(f, :private, "Public") %>
              <%= radio_button(f, :private, false) %>
            </div>

            <%= if @uploads.audio.entries |> Enum.any? do %>
              <div class="pt-5">
                <div class="flex items-center justify-end">
                  <%= live_redirect to: Routes.profile_index_path(@socket, :index, @current_user.username), class: "bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" do %>
                    Cancel
                  <% end %>
                  <%= submit(gettext("Continue"),
                    phx_disable_with: gettext("Saving..."),
                    class:
                      "ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500"
                  ) %>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </.form>
    </div>
    """
  end
end
