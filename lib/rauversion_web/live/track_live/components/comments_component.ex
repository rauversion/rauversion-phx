defmodule RauversionWeb.TrackLive.CommentsComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  alias Rauversion.{Repo}

  @impl true
  def update(assigns = assigns = %{current_user: _user = nil}, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:comment_changeset, nil)
      |> assign(
        :comments,
        assigns.track
        |> Ecto.assoc(:track_comments)
        |> Repo.all()
        |> Repo.preload(user: [:avatar_blob])
      )
      |> assign(:temporary_assigns, comments: [])
    }
  end

  @impl true
  def update(assigns = %{current_user: _user = %Rauversion.Accounts.User{}}, socket) do
    comment_changeset =
      Rauversion.TrackComments.change_track_comment(
        %Rauversion.TrackComments.TrackComment{},
        %{
          track_id: assigns.track.id,
          user_id: assigns.current_user.id
        }
      )

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:comment_changeset, comment_changeset)
      |> assign(
        :comments,
        assigns.track
        |> Ecto.assoc(:track_comments)
        |> Repo.all()
        |> Repo.preload(user: [:avatar_blob])
      )
      |> assign(:temporary_assigns, comments: [])
    }
  end

  @impl true
  def handle_event(
        "validate",
        %{"_target" => ["track_comment", "body"], "track_comment" => %{"body" => _body}},
        socket
      ) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"track_comment" => %{"body" => comment}}, socket) do
    case Rauversion.TrackComments.create_track_comment(%{
           user_id: socket.assigns.current_user.id,
           track_id: socket.assigns.track.id,
           body: comment
         }) do
      {:ok, comment} ->
        comment = comment |> Repo.preload(:user)
        # assign(socket, :comments, comment)

        {:noreply, update(socket, :comments, fn messages -> [comment | messages] end)}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section aria-labelledby="activity-title" class="mt-8 xl:mt-10">
      <div>
        <div class="divide-y divide-gray-200 dark:divide-gray-800">
          <div class="pb-4">
            <h2 id="activity-title" class="text-lg font-medium text-gray-900 dark:text-gray-100">
              <%= gettext("Activity") %>
            </h2>
          </div>
          <div class="pt-6">
            <!-- Activity feed-->
            <div class="flow-root">
              <ul id="track-comments-list" role="list" class="-mb-8" phx-update="append">
                <%= for comment <- @comments do %>
                  <li id={"comment-#{comment.id}"}>
                    <div class="relative pb-8">
                      <span
                        class="absolute top-5 left-5 -ml-px h-full w-0.5 bg-gray-200"
                        aria-hidden="true"
                      >
                      </span>
                      <div class="relative flex items-start space-x-3">
                        <div class="relative">
                          <%= img_tag(Rauversion.Accounts.avatar_url(comment.user, :small),
                            class:
                              "h-10 w-10 rounded-full bg-gray-400 flex items-center justify-center ring-8 ring-white",
                            alt: comment.user.username
                          ) %>

                          <span class="absolute -bottom-0.5 -right-1 bg-white rounded-tl px-0.5 py-px">
                            <svg
                              class="h-5 w-5 text-gray-400"
                              x-description="Heroicon name: solid/chat-alt"
                              xmlns="http://www.w3.org/2000/svg"
                              viewBox="0 0 20 20"
                              fill="currentColor"
                              aria-hidden="true"
                            >
                              <path
                                fill-rule="evenodd"
                                d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zM7 8H5v2h2V8zm2 0h2v2H9V8zm6 0h-2v2h2V8z"
                                clip-rule="evenodd"
                              >
                              </path>
                            </svg>
                          </span>
                        </div>
                        <div class="min-w-0 flex-1">
                          <div>
                            <div class="text-sm">
                              <%= live_redirect to: Routes.profile_index_path(@socket, :index, comment.user.username),
                                  class: "font-medium text-gray-900 dark:text-gray-100" do %>
                                <%= comment.user.username %>
                              <% end %>
                            </div>
                            <p class="mt-0.5 text-sm text-gray-500 dark:text-gray-400">
                              Commented <%= comment.inserted_at %>
                            </p>
                          </div>
                          <div class="mt-2 text-sm text-gray-700 dark:text-gray-300">
                            <p>
                              <%= comment.body %>
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>

            <%= if assigns.comment_changeset do %>
              <div class="mt-6">
                <div class="flex space-x-5">
                  <div class="flex-shrink-0">
                    <div class="relative">
                      <%= img_tag(Rauversion.Accounts.avatar_url(@current_user, :small),
                        class:
                          "h-10 w-10 rounded-full bg-gray-400 flex items-center justify-center ring-8 ring-white",
                        alt: @current_user.username
                      ) %>

                      <span class="absolute -bottom-0.5 -right-1 bg-white rounded-tl px-0.5 py-px">
                        <svg
                          class="h-5 w-5 text-gray-400"
                          x-description="Heroicon name: solid/chat-alt"
                          xmlns="http://www.w3.org/2000/svg"
                          viewBox="0 0 20 20"
                          fill="currentColor"
                          aria-hidden="true"
                        >
                          <path
                            fill-rule="evenodd"
                            d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zM7 8H5v2h2V8zm2 0h2v2H9V8zm6 0h-2v2h2V8z"
                            clip-rule="evenodd"
                          >
                          </path>
                        </svg>
                      </span>
                    </div>
                  </div>

                  <div class="min-w-0 flex-1">
                    <.form
                      :let={f}
                      for={@comment_changeset}
                      id="track-comments"
                      phx-change="validate"
                      phx-submit="save"
                      phx-target={@myself}
                      class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
                    >
                      <div>
                        <label for="comment" class="sr-only">Comment</label>
                        <%= textarea(f, :body,
                          rows: 3,
                          class:
                            "shadow-sm block w-full focus:ring-gray-900 focus:border-gray-900 sm:text-sm border border-gray-300 dark:border-gray-700 rounded-md dark:bg-gray-900 dark:text-gray-100",
                          placeholder: "Leave a comment"
                        ) %>
                      </div>

                      <div class="mt-6 flex items-center justify-end space-x-4 py-4">
                        <%= submit(gettext("Comment"),
                          phx_disable_with: gettext("Saving..."),
                          "data-cy": "comment-submit",
                          class: "button-large"
                        ) %>
                      </div>
                    </.form>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
