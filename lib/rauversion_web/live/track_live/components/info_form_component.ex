defmodule RauversionWeb.TrackLive.InfoFormComponent do
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
        id={"info-track-form-#{@track.id}"}
        phx-target={@target}
        phx-change="validate"
        phx-submit="save"
        multipart={true}
        class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
      >
        <div class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800 sm:space-y-5">
          <div>
            <div>
              <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                Profile <%= @track.id %>
                <%= @track.title %>
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                <%= gettext(
                  "This information will be displayed publicly so be careful what you share."
                ) %>
              </p>
            </div>

            <div class="mt-6 sm:mt-5 space-y-6 sm:space-y-5">
              <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5">
                <%= label(f, :title,
                  class: "block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2"
                ) %>

                <div class="mt-1 sm:mt-0 sm:col-span-2">
                  <div class="max-w-lg flex rounded-md shadow-sm">
                    <%= text_input(f, :title,
                      class:
                        "flex-1 block w-full focus:ring-brand-500 focus:border-brand-500 min-w-0 rounded-none rounded-r-md sm:text-sm border-gray-300 dark:bg-gray-900 dark:text-gray-100"
                    ) %>
                    <%= error_tag(f, :title) %>
                  </div>
                </div>
              </div>

              <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5">
                <%= label(f, :description,
                  class: "block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2"
                ) %>

                <div class="mt-1 sm:mt-0 sm:col-span-2">
                  <%= textarea(f, :description,
                    class:
                      "max-w-lg shadow-sm block w-full focus:ring-brand-500 focus:border-brand-500 sm:text-sm border border-gray-300 rounded-md dark:bg-gray-900 dark:text-gray-100"
                  ) %>
                  <%= error_tag(f, :description) %>
                  <p class="mt-2 text-sm text-gray-500">
                    <%= gettext("Write the track's description.") %>
                  </p>
                </div>
              </div>

              <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-start sm:border-t sm:border-gray-200 sm:pt-5">
                <label
                  for="cover-photo"
                  class="block text-sm font-medium text-gray-700 dark:text-gray-300 sm:mt-px sm:pt-2"
                >
                  <%= gettext("Cover photo") %>
                </label>

                <div class="mt-1 sm:mt-0 sm:col-span-2">
                  <div
                    class="max-w-lg flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md"
                    phx-drop-target={@uploads.cover.ref}
                  >
                    <div class="space-y-1 text-center">
                      <svg
                        class="mx-auto h-12 w-12 text-gray-400"
                        stroke="currentColor"
                        fill="none"
                        viewBox="0 0 48 48"
                        aria-hidden="true"
                      >
                        <path
                          d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                          stroke-width="2"
                          stroke-linecap="round"
                          stroke-linejoin="round"
                        >
                        </path>
                      </svg>

                      <div class="flex text-sm text-gray-600 py-3">
                        <label class="relative cursor-pointer rounded-md font-medium text-brand-600 hover:text-brand-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-brand-500">
                          <span><%= gettext("Upload a track Cover") %></span>
                          <.live_file_input upload={@uploads.cover} class="hidden" />
                          <% # = live_file_input @uploads.cover, class: "hidden" %>
                        </label>
                        <p class="pl-1"><%= gettext("or drag and drop") %></p>
                      </div>

                      <div>
                        <%= for entry <- @uploads.cover.entries do %>
                          <div class="flex items-center space-x-2">
                            <.live_img_preview entry={entry} width={300} />
                            <div class="text-xl font-bold">
                              <%= entry.progress %>%
                            </div>
                          </div>
                        <% end %>

                        <%= for {_ref, msg, } <- @uploads.cover.errors do %>
                          <%= Phoenix.Naming.humanize(msg) %>
                        <% end %>
                      </div>

                      <p class="text-xs text-gray-500">
                        <%= gettext("PNG, JPG, GIF up to 10MB") %>
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="hidden divide-y divide-gray-200 dark:divide-gray-800 pt-8 space-y-6 sm:pt-10 sm:space-y-5">
            <div>
              <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-gray-100">
                <%= gettext("Notifications") %>
              </h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                <%= gettext(
                  "We'll always let you know about important changes, but you pick what else you want to hear about."
                ) %>
              </p>
            </div>
            <div class="space-y-6 sm:space-y-5 divide-y divide-gray-200">
              <div class="pt-6 sm:pt-5">
                <div role="group" aria-labelledby="label-email">
                  <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-baseline">
                    <div>
                      <div
                        class="text-base font-medium text-gray-900 sm:text-sm sm:text-gray-700 dark:text-gray-300"
                        id="label-email"
                      >
                        <%= gettext("By Email") %>
                      </div>
                    </div>
                    <div class="mt-4 sm:mt-0 sm:col-span-2">
                      <div class="max-w-lg space-y-4">
                        <div class="relative flex items-start">
                          <div class="flex items-center h-5">
                            <input
                              id="comments"
                              name="comments"
                              type="checkbox"
                              class="focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300 rounded"
                            />
                          </div>
                          <div class="ml-3 text-sm">
                            <label for="comments" class="font-medium text-gray-700 dark:text-gray-300">
                              <%= gettext("Comments") %>
                            </label>
                            <p class="text-gray-500">
                              <%= gettext("Get notified when someones posts a comment on a posting.") %>
                            </p>
                          </div>
                        </div>
                        <div>
                          <div class="relative flex items-start">
                            <div class="flex items-center h-5">
                              <input
                                id="candidates"
                                name="candidates"
                                type="checkbox"
                                class="focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300 rounded"
                              />
                            </div>
                            <div class="ml-3 text-sm">
                              <label
                                for="candidates"
                                class="font-medium text-gray-700 dark:text-gray-300"
                              >
                                Candidates
                              </label>
                              <p class="text-gray-500">
                                <%= gettext("Get notified when a candidate applies for a job.") %>
                              </p>
                            </div>
                          </div>
                        </div>
                        <div>
                          <div class="relative flex items-start">
                            <div class="flex items-center h-5">
                              <input
                                id="offers"
                                name="offers"
                                type="checkbox"
                                class="focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300 rounded"
                              />
                            </div>
                            <div class="ml-3 text-sm">
                              <label for="offers" class="font-medium text-gray-700 dark:text-gray-300">
                                <%= gettext("Offers") %>
                              </label>
                              <p class="text-gray-500">
                                <%= gettext(
                                  "Get notified when a candidate accepts or rejects an offer."
                                ) %>
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="pt-6 sm:pt-5">
                <div role="group" aria-labelledby="label-notifications">
                  <div class="sm:grid sm:grid-cols-3 sm:gap-4 sm:items-baseline">
                    <div>
                      <div
                        class="text-base font-medium text-gray-900 sm:text-sm sm:text-gray-700 dark:text-gray-300"
                        id="label-notifications"
                      >
                        <%= gettext("Push Notifications") %>
                      </div>
                    </div>
                    <div class="sm:col-span-2">
                      <div class="max-w-lg">
                        <p class="text-sm text-gray-500">
                          <%= gettext("These are delivered via SMS to your mobile phone.") %>
                        </p>
                        <div class="mt-4 space-y-4">
                          <div class="flex items-center">
                            <input
                              id="push-everything"
                              name="push-notifications"
                              type="radio"
                              class="focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300"
                            />
                            <label
                              for="push-everything"
                              class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300"
                            >
                              <%= gettext("Everything") %>
                            </label>
                          </div>
                          <div class="flex items-center">
                            <input
                              id="push-email"
                              name="push-notifications"
                              type="radio"
                              class="focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300"
                            />
                            <label
                              for="push-email"
                              class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300"
                            >
                              <%= gettext("Same as email") %>
                            </label>
                          </div>
                          <div class="flex items-center">
                            <input
                              id="push-nothing"
                              name="push-notifications"
                              type="radio"
                              class="focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300"
                            />
                            <label
                              for="push-nothing"
                              class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300"
                            >
                              <%= gettext("No push notifications") %>
                            </label>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="pt-5">
          <div class="flex justify-center">
            <%= live_redirect to: "/", class: "bg-white py-2 px-4 border border-gray-300 dark:border-gray-700 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" do %>
              <%= gettext("Cancel") %>
            <% end %>
            <%= submit(gettext("Save"),
              phx_disable_with: gettext("Saving..."),
              class:
                "ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500"
            ) %>
          </div>
        </div>
      </.form>
    </div>
    """
  end
end
