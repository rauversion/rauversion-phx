defmodule RauversionWeb.ArticlesLive.FormPublishComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Posts}

  def update(%{post: post} = assigns, socket) do
    changeset = Posts.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:cover, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Posts.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"post" => post_params}, socket) do
    post_params =
      post_params
      |> Map.put("cover", List.first(files_for(socket, :cover)))
      |> Map.put("state", "published")

    case Posts.update_post_attributes(socket.assigns.post, post_params) do
      {:ok, post} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "post updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="">

      <div class="">

        <.form
          let={f}
          for={@changeset}
          id="post-form-2"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
          multipart={true}
          class=""
        >
          <div class="">

            <div class="">
              <div class="divide-y divide-gray-200 px-4 sm:px-6">

                <div class="space-y-6 pt-6 pb-5">
                  <div>
                    <%= label f, :title, class: "block text-sm font-medium text-gray-900" %>
                    <div class="mt-1">
                      <%= text_input f, :title, class: "block w-full rounded-md border-gray-300 shadow-sm focus:border-brand-500 focus:ring-brand-500 sm:text-sm" %>
                      <%= error_tag f, :title %>
                    </div>
                  </div>
                  <div>
                    <%= label f, :excerpt, class: "block text-sm font-medium text-gray-900" %>
                    <div class="mt-1">
                      <%= textarea f, :excerpt, class: "block w-full rounded-md border-gray-300 shadow-sm focus:border-brand-500 focus:ring-brand-500 sm:text-sm" %>
                      <%= error_tag f, :excerpt %>
                    </div>
                  </div>

                  <fieldset>
                    <legend class="text-sm font-medium text-gray-900">Privacy</legend>
                    <div class="mt-2 space-y-5">
                      <div class="relative flex items-start">
                        <div class="absolute flex h-5 items-center">
                          <%= radio_button(f, :private, false, class: "h-4 w-4 border-gray-300 text-brand-600 focus:ring-brand-500") %>
                        </div>
                        <div class="pl-7 text-sm">
                          <label for="privacy-public" class="font-medium text-gray-900"> Public access </label>
                          <p id="privacy-public-description" class="text-gray-500">Everyone with the link will see this article.</p>
                        </div>
                      </div>
                      <div>
                        <div class="relative flex items-start">
                          <div class="absolute flex h-5 items-center">
                            <%= radio_button(f, :private, true, class: "h-4 w-4 border-gray-300 text-brand-600 focus:ring-brand-500") %>
                          </div>
                          <div class="pl-7 text-sm">
                            <label for="privacy-private-to-article" class="font-medium text-gray-900"> Private to article members </label>
                            <p id="privacy-private-to-article-description" class="text-gray-500">Only members of this article would be able to access.</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </fieldset>
                </div>

                <div class="pt-4 pb-6">
                  <div class="flex text-sm">
                    <a href="#" class="group inline-flex items-center font-medium text-brand-600 hover:text-brand-900">
                      <svg class="h-5 w-5 text-brand-500 group-hover:text-brand-900" x-description="Heroicon name: solid/link" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M12.586 4.586a2 2 0 112.828 2.828l-3 3a2 2 0 01-2.828 0 1 1 0 00-1.414 1.414 4 4 0 005.656 0l3-3a4 4 0 00-5.656-5.656l-1.5 1.5a1 1 0 101.414 1.414l1.5-1.5zm-5 5a2 2 0 012.828 0 1 1 0 101.414-1.414 4 4 0 00-5.656 0l-3 3a4 4 0 105.656 5.656l1.5-1.5a1 1 0 10-1.414-1.414l-1.5 1.5a2 2 0 11-2.828-2.828l3-3z" clip-rule="evenodd"></path>
                      </svg>
                      <span class="ml-2"> Copy link </span>
                    </a>
                  </div>
                  <div class="mt-4 flex text-sm">
                    <a href="#" class="group inline-flex items-center text-gray-500 hover:text-gray-900">
                      <svg class="h-5 w-5 text-gray-400 group-hover:text-gray-500" x-description="Heroicon name: solid/question-mark-circle" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd"></path>
                      </svg>
                      <span class="ml-2"> Learn more about sharing </span>
                    </a>
                  </div>
                </div>

              </div>
            </div>
          </div>

          <div class="flex flex-shrink-0 justify-end px-4 py-4">
            <button
              type="button"
              class="rounded-md border border-gray-300 bg-white py-2 px-4 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2"
              phx-click="cancel-publish-modal">
              Cancel
            </button>

            <%= submit "Save & Publish", phx_disable_with: "Saving...", class: "ml-4 inline-flex justify-center rounded-md border border-transparent bg-brand-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2" %>
          </div>
        </.form>
      </div>
    </div>

    """
  end
end
