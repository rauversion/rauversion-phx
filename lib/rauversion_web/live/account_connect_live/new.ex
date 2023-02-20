defmodule RauversionWeb.AccountConnectLive.New do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:op, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("add-existing", _, socket) do
    {:noreply, socket |> assign(:op, "existing")}
  end

  @impl true
  def handle_event("add-new", _, socket) do
    changeset = Rauversion.Accounts.change_user_profile(%Rauversion.Accounts.User{}, %{})
    {:noreply, socket |> assign(:op, "new") |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("cancel", _, socket) do
    {:noreply, socket |> assign(:op, nil)}
  end

  def default_class do
    "pointer-events-auto w-[21rem] rounded-lg bg-white dark:bg-gray-900 p-4 text-[0.8125rem] leading-5 shadow-xl shadow-black/5 hover:bg-slate-50 ring-1 ring-slate-700/10"
  end

  def selected_class do
    "pointer-events-auto w-[21rem] rounded-lg bg-white dark:bg-gray-900 p-4 text-[0.8125rem] leading-5 shadow-xl shadow-black/5 hover:bg-slate-50 ring-2 ring-indigo-600"
  end

  def option(assigns) do
    ~H"""
    <div phx-click={@action} class={if @selected, do: selected_class(), else: default_class()}>
      <div class="flex justify-between">
        <div class="font-medium text-slate-900 dark:text-slate-100">
          <%= @label %>
        </div>
        <svg class="h-5 w-5 flex-none" fill="none">
          <path
            fill-rule="evenodd"
            clip-rule="evenodd"
            d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.707-9.293a1 1 0 0 0-1.414-1.414L9 10.586 7.707 9.293a1 1 0 0 0-1.414 1.414l2 2a1 1 0 0 0 1.414 0l4-4Z"
            fill="#4F46E5"
          >
          </path>
        </svg>
      </div>
      <div class="mt-1 text-slate-700 dark:text-slate-300">Last message sent an hour ago</div>
      <div class="hidden mt-6 font-medium text-slate-900 dark:text-slate-100">1200 users</div>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative mx-auto mt-16 grid w-full max-w-container grid-cols-1 px-4 sm:mt-20 sm:px-6 lg:px-8 xl:mt-32">
      <%= @op %>
      <div class="relative z-10 p-4">
        <div class="space-x-4 flex justify-center">
          <.option label={gettext("New artist")} action="add-new" selected={@op == "new"} />
          <.option
            label={gettext("Existing Artist")}
            action="add-existing"
            selected={@op == "existing"}
          />
        </div>
      </div>

      <button phx-click="cancel">cancel</button>

      <div :if={@op == "new"}>
        new user form here <%= live_component(RauversionWeb.AccountConnectLive.NewUser,
          id: "new-user-connect",
          changeset: @changeset,
          current_user: @current_user
        ) %>
      </div>

      <div :if={@op == "existing"}>
        existing form here
      </div>
    </div>
    """
  end
end
