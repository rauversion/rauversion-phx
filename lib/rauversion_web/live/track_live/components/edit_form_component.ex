defmodule RauversionWeb.TrackLive.EditFormComponent do
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
        let={f}
        for={@changeset}
        id="track-form-2"
        phx-target={@target}
        phx-change="validate"
        phx-submit="save"
        multipart={true}
        class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
      >

        <div>
          <div class="sm:hidden">
            <label for="tabs" class="sr-only">Select a tab</label>
            <!-- Use an "onChange" listener to redirect the user to the selected tab URL. -->
            <select id="tabs" name="tabs" class="block w-full focus:ring-indigo-500 focus:border-indigo-500 border-gray-300 rounded-md">
              <option>Basic Info</option>

              <option>Metadata</option>

              <option selected>Permissions</option>

              <option>Share</option>
            </select>
          </div>

          <div class="hidden sm:block">
            <% #= @current_tab %>
            <nav class="flex space-x-4" aria-label="Tabs" data-controller-dis="tabs">
              <!-- Current: "bg-indigo-100 text-indigo-700", Default: "text-gray-500 hover:text-gray-700 dark:text-gray-300" -->
              <a href="#" phx-click="basic-info-tab" class={"#{active_tab_link?(@current_tab, "basic-info-tab")} tab-link px-3 py-2 font-medium text-sm rounded-md"}> Basic Info </a>
              <a href="#" phx-click="metadata-tab" class={"#{active_tab_link?(@current_tab, "metadata-tab")} tab-link px-3 py-2 font-medium text-sm rounded-md"}> Metadata </a>
              <a href="#" phx-click="permissions-tab" class={"#{active_tab_link?(@current_tab, "permissions-tab")} tab-link px-3 py-2 font-medium text-sm rounded-md"} aria-current="page"> Permissions </a>
              <a href="#" phx-click="share-tab" class={"#{active_tab_link?(@current_tab, "share-tab")} tab-link px-3 py-2 font-medium text-sm rounded-md"}> Share </a>
            </nav>

            <div id="basic-info" class={"tab-pane #{ active_tab_for?(@current_tab, "basic-info-tab") }"}>
              <div class="pt-8 space-y-8 divide-y divide-gray-200 dark:divide-gray-800 sm:space-y-5">
                <div>
                  <div>
                    <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                      Profile <%= @track.id %>
                      <%= @track.title %>
                    </h3>
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">
                      This information will be displayed publicly so be careful what you share.
                    </p>
                  </div>

                  <div class="mt-6 sm:mt-5 space-y-6 sm:space-y-5">
                    <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5">
                      <%= label f, :title, class: "block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2" %>
                      <div class="mt-1 sm:mt-0 sm:col-span-2">
                        <div class="max-w-lg flex rounded-md shadow-sm">
                          <%= text_input f, :title, class: "flex-1 block w-full focus:ring-brand-500 focus:border-brand-500 min-w-0 rounded-none rounded-r-md sm:text-sm border-gray-300 dark:bg-gray-900 dark:text-gray-100" %>
                          <%= error_tag f, :title %>
                        </div>
                      </div>
                    </div>

                    <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5">
                      <%= label f, :description, class: "block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2" %>
                      <div class="mt-1 sm:mt-0 sm:col-span-2">
                        <div class="max-w-lg flex rounded-md shadow-sm">
                          <%= textarea f, :description, class: "flex-1 block w-full focus:ring-brand-500 focus:border-brand-500 min-w-0 rounded-none rounded-r-md sm:text-sm border-gray-300 dark:bg-gray-900 dark:text-gray-100" %>
                          <%= error_tag f, :description %>
                        </div>
                      </div>
                    </div>

                    <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5">
                      <label for="cover-photo" class="block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2">
                        Cover photo
                      </label>

                      <div class="mt-1 sm:mt-0 sm:col-span-2">
                        <div class="max-w-lg flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md"
                          phx-drop-target={@uploads.cover.ref}>
                          <div class="space-y-1 text-center">
                            <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                              <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg>

                            <div class="flex text-sm text-gray-600 py-3">
                              <label class="relative cursor-pointer rounded-md font-medium text-brand-600 hover:text-brand-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-brand-500">
                                <span>Upload a track Cover</span>
                                <% #= form.file_field :audio, direct_upload: true, id: "file-audio-upload", class: "sr-only" %>
                                <%= live_file_input @uploads.cover,
                                  # id: "track_cover",
                                  class: "hidden"
                                %>
                              </label>
                              <p class="pl-1">or drag and drop</p>
                            </div>

                            <div>
                              <%= for entry <- @uploads.cover.entries do %>
                                <div class="flex items-center space-x-2">
                                  <%= live_img_preview entry, width: 300 %>
                                  <div class="text-xl font-bold">
                                    <%= entry.progress %>%
                                  </div>
                                </div>
                              <% end  %>

                              <%= for {_ref, msg, } <- @uploads.cover.errors do %>
                                <%= Phoenix.Naming.humanize(msg) %>
                              <% end %>
                            </div>

                            <p class="text-xs text-gray-500">
                              PNG, JPG, GIF up to 10MB
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5">
                      <%= label f, :private, "Privacy", class: "block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2" %>

                      <div class="flex-col space-y-3">
                        <div class="flex space-x-2 items-center">
                          <%= radio_button f, :private, false %>
                          <%= label f, :private, "Public", class: "" %>
                        </div>

                        <div class="flex space-x-2 items-center">
                          <%= radio_button f, :private, true %>
                          <%= label f, :private, "Private", class: "" %>
                        </div>
                      </div>
                    </div>




                  </div>
                </div>
              </div>
            </div>

            <div class="hidden block sm:col-span-4"></div>


            <%= inputs_for f, :metadata, fn i -> %>

              <div id="metadata" class={"tab-pane #{ active_tab_for?(@current_tab, "metadata-tab") }"}>
                <div class="pt-8">
                  <div>
                    <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                      Metadata information
                    </h3>
                    <p class="mt-1 text-sm text-gray-500">
                     Track information
                    </p>
                  </div>
                  <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                    <%= for field <- Rauversion.Tracks.TrackMetadata.form_definitions("metadata") do %>
                      <%= form_input_renderer(i, field) %>
                    <% end %>
                  </div>

                  <div class="my-4 py-4 border-t flex space-x-4 items-center">
                    <div class="space-x-2 flex items-center">
                      <%= radio_button i, :copyright, "all-rights" %>
                      <%= label i, "All rights reserved" %>
                    </div>

                    <div class="space-x-2 flex items-center">
                      <%= radio_button i, :copyright, "common" %>
                      <%= label i, "Creative commons" %>

                      <div class="text-sm text-gray-700 dark:text-gray-300 flex space-x-2 items-center">
                        <%= if i.params["copyright"] == "common" || (!i.params["copyright"] && i.data.copyright == "common")  do %>
                          <% #= i.params["noncommercial"] %>

                          <div class="flex space-x-2 mx-2">

                            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="25px" height="25px" viewBox="5.5 -3.5 64 64" enable-background="new 5.5 -3.5 64 64">
                              <g>
                                <circle fill="#FFFFFF" cx="37.637" cy="28.806" r="28.276"/>
                                <g>
                                  <path d="M37.443-3.5c8.988,0,16.57,3.085,22.742,9.257C66.393,11.967,69.5,19.548,69.5,28.5c0,8.991-3.049,16.476-9.145,22.456    C53.879,57.319,46.242,60.5,37.443,60.5c-8.649,0-16.153-3.144-22.514-9.43C8.644,44.784,5.5,37.262,5.5,28.5    c0-8.761,3.144-16.342,9.429-22.742C21.101-0.415,28.604-3.5,37.443-3.5z M37.557,2.272c-7.276,0-13.428,2.553-18.457,7.657    c-5.22,5.334-7.829,11.525-7.829,18.572c0,7.086,2.59,13.22,7.77,18.398c5.181,5.182,11.352,7.771,18.514,7.771    c7.123,0,13.334-2.607,18.629-7.828c5.029-4.838,7.543-10.952,7.543-18.343c0-7.276-2.553-13.465-7.656-18.571    C50.967,4.824,44.795,2.272,37.557,2.272z M46.129,20.557v13.085h-3.656v15.542h-9.944V33.643h-3.656V20.557    c0-0.572,0.2-1.057,0.599-1.457c0.401-0.399,0.887-0.6,1.457-0.6h13.144c0.533,0,1.01,0.2,1.428,0.6    C45.918,19.5,46.129,19.986,46.129,20.557z M33.042,12.329c0-3.008,1.485-4.514,4.458-4.514s4.457,1.504,4.457,4.514    c0,2.971-1.486,4.457-4.457,4.457S33.042,15.3,33.042,12.329z"/>
                                </g>
                              </g>
                            </svg>

                            <%= if i.params["noncommercial"] == "true" || (!i.params["noncommercial"] && i.data.noncommercial) || (i.params["noncommercial"] == false && !i.data.noncommercial)  do %>
                              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="25px" height="25px" viewBox="5.5 -3.5 64 64" enable-background="new 5.5 -3.5 64 64">
                                <g>
                                  <circle fill="#FFFFFF" cx="37.47" cy="28.736" r="29.471"/>
                                  <g>
                                    <path d="M37.442-3.5c8.99,0,16.571,3.085,22.743,9.256C66.393,11.928,69.5,19.509,69.5,28.5c0,8.992-3.048,16.476-9.145,22.458    C53.88,57.32,46.241,60.5,37.442,60.5c-8.686,0-16.19-3.162-22.513-9.485C8.644,44.728,5.5,37.225,5.5,28.5    c0-8.762,3.144-16.343,9.429-22.743C21.1-0.414,28.604-3.5,37.442-3.5z M12.7,19.872c-0.952,2.628-1.429,5.505-1.429,8.629    c0,7.086,2.59,13.22,7.77,18.4c5.219,5.144,11.391,7.715,18.514,7.715c7.201,0,13.409-2.608,18.63-7.829    c1.867-1.79,3.332-3.657,4.398-5.602l-12.056-5.371c-0.421,2.02-1.439,3.667-3.057,4.942c-1.622,1.276-3.535,2.011-5.744,2.2    v4.915h-3.714v-4.915c-3.543-0.036-6.782-1.312-9.714-3.827l4.4-4.457c2.094,1.942,4.476,2.913,7.143,2.913    c1.104,0,2.048-0.246,2.83-0.743c0.78-0.494,1.172-1.312,1.172-2.457c0-0.801-0.287-1.448-0.858-1.943l-3.085-1.315l-3.771-1.715    l-5.086-2.229L12.7,19.872z M37.557,2.214c-7.276,0-13.428,2.571-18.457,7.714c-1.258,1.258-2.439,2.686-3.543,4.287L27.786,19.7    c0.533-1.676,1.542-3.019,3.029-4.028c1.484-1.009,3.218-1.571,5.2-1.686V9.071h3.715v4.915c2.934,0.153,5.6,1.143,8,2.971    l-4.172,4.286c-1.793-1.257-3.619-1.885-5.486-1.885c-0.991,0-1.876,0.191-2.656,0.571c-0.781,0.381-1.172,1.029-1.172,1.943    c0,0.267,0.095,0.533,0.285,0.8l4.057,1.83l2.8,1.257l5.144,2.285l16.397,7.314c0.535-2.248,0.801-4.533,0.801-6.857    c0-7.353-2.552-13.543-7.656-18.573C51.005,4.785,44.831,2.214,37.557,2.214z"/>
                                  </g>
                                </g>
                              </svg>
                            <% end %>

                            <%= if i.params["copies"] == "non_derivative_works" || (!i.params["copies"] && i.data.copies == "non_derivative_works") do %>
                              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="25px" height="25px" viewBox="0 0 64.000977 64" enable-background="new 0 0 64.000977 64">
                                <g>
                                  <circle fill="#FFFFFF" cx="32.064453" cy="31.788086" r="29.012695"/>
                                  <g>
                                    <path d="M31.943848,0C40.896484,0,48.476562,3.105469,54.6875,9.314453C60.894531,15.486328,64.000977,23.045898,64.000977,32    s-3.048828,16.457031-9.145508,22.513672C48.417969,60.837891,40.779297,64,31.942871,64    c-8.648926,0-16.152832-3.142578-22.513672-9.429688C3.144043,48.286133,0,40.761719,0,32.000977    c0-8.723633,3.144043-16.285156,9.429199-22.68457C15.640137,3.105469,23.14502,0,31.943848,0z M32.060547,5.771484    c-7.275391,0-13.429688,2.570312-18.458496,7.714844C8.381836,18.783203,5.772949,24.954102,5.772949,32    c0,7.125,2.589844,13.256836,7.77002,18.400391c5.181152,5.181641,11.352051,7.770508,18.515625,7.770508    c7.123047,0,13.332031-2.608398,18.626953-7.828125C55.713867,45.466797,58.228516,39.353516,58.228516,32    c0-7.3125-2.553711-13.484375-7.65625-18.513672C45.504883,8.341797,39.333984,5.771484,32.060547,5.771484z M44.117188,24.456055    v5.485352H20.859863v-5.485352H44.117188z M44.117188,34.743164v5.481445H20.859863v-5.481445H44.117188z"/>
                                  </g>
                                </g>
                              </svg>
                            <% end %>

                            <%= if i.params["copies"] == "share_alike" || (!i.params["copies"] && i.data.copies == "share_alike") do %>
                              <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="25px" height="25px" viewBox="5.5 -3.5 64 64" enable-background="new 5.5 -3.5 64 64">
                                <g>
                                  <circle fill="#FFFFFF" cx="36.944" cy="28.631" r="29.105"/>
                                  <g>
                                    <path d="M37.443-3.5c8.951,0,16.531,3.105,22.742,9.315C66.393,11.987,69.5,19.548,69.5,28.5c0,8.954-3.049,16.457-9.145,22.514    C53.918,57.338,46.279,60.5,37.443,60.5c-8.649,0-16.153-3.143-22.514-9.429C8.644,44.786,5.5,37.264,5.5,28.501    c0-8.723,3.144-16.285,9.429-22.685C21.138-0.395,28.643-3.5,37.443-3.5z M37.557,2.272c-7.276,0-13.428,2.572-18.457,7.715    c-5.22,5.296-7.829,11.467-7.829,18.513c0,7.125,2.59,13.257,7.77,18.4c5.181,5.182,11.352,7.771,18.514,7.771    c7.123,0,13.334-2.609,18.629-7.828c5.029-4.876,7.543-10.99,7.543-18.343c0-7.313-2.553-13.485-7.656-18.513    C51.004,4.842,44.832,2.272,37.557,2.272z M23.271,23.985c0.609-3.924,2.189-6.962,4.742-9.114    c2.552-2.152,5.656-3.228,9.314-3.228c5.027,0,9.029,1.62,12,4.856c2.971,3.238,4.457,7.391,4.457,12.457    c0,4.915-1.543,9-4.627,12.256c-3.088,3.256-7.086,4.886-12.002,4.886c-3.619,0-6.743-1.085-9.371-3.257    c-2.629-2.172-4.209-5.257-4.743-9.257H31.1c0.19,3.886,2.533,5.829,7.029,5.829c2.246,0,4.057-0.972,5.428-2.914    c1.373-1.942,2.059-4.534,2.059-7.771c0-3.391-0.629-5.971-1.885-7.743c-1.258-1.771-3.066-2.657-5.43-2.657    c-4.268,0-6.667,1.885-7.2,5.656h2.343l-6.342,6.343l-6.343-6.343L23.271,23.985L23.271,23.985z"/>
                                  </g>
                                </g>
                              </svg>
                            <% end %>
                          </div>

                          some rights reserved
                        <% end %>
                      </div>
                    </div>
                  </div>


                  <%= if i.params["copyright"] == "common" || (!i.params["copyright"] && i.data.copyright == "common")  do %>
                    <%= render_attribution_fields(i) %>
                  <% end %>
                </div>
              </div>

              <div id="permissions" class={"tab-pane #{ active_tab_for?(@current_tab, "permissions-tab")} "}>
                <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                  <%= for field <- Rauversion.Tracks.TrackMetadata.form_definitions("permissions") do %>
                    <%= form_input_renderer(i, field) %>
                  <% end %>
                </div>
              </div>

            <% end %>

            <div id="share" class={"tab-pane #{ active_tab_for?(@current_tab, "share-tab")}"}>
              share controls
            </div>

          </div>
        </div>

        <div class="pt-5">
          <div class="flex justify-center">
            <%= live_redirect to: "/", class: "bg-white dark:bg-black py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" do %>
              Cancel
            <%end %>
            <%= submit "Save", phx_disable_with: "Saving...", class: "ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
          </div>
        </div>

      </.form>
    </div>

    """
  end
end
