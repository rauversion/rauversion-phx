defmodule RauversionWeb.UsersettingsLive.IntegrationsForm do
  use RauversionWeb, :live_component
  alias Rauversion.Repo

  @impl true
  def update(assigns, socket) do
    integrations = get_integrations(assigns.current_user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:integrations, integrations)
     |> assign(:providers, providers(integrations))}
  end

  defp providers(integrations) do
    provider_keys =
      Application.get_env(:ueberauth, Ueberauth)
      |> Keyword.get(:providers)
      |> Enum.map(fn {z, _} -> Atom.to_string(z) end)

    existing_providers = integrations |> Enum.map(fn i -> i.provider end)

    provider_keys -- existing_providers
  end

  defp get_integrations(user) do
    user |> Ecto.assoc(:oauth_credentials) |> Repo.all()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
    <h1 class="text-3xl font-extrabold text-blue-gray-900">Integrations</h1>

      <div class="py-6">
        <h2 class="text-gray-500 dark:text-gray-300 text-sm font-medium">
          Your integrations
        </h2>
        <ul role="list" class="mt-3 grid grid-cols-1 gap-5 sm:gap-6 sm:grid-cols-2 lg:grid-cols-4">
          <%= for integration <- @integrations do %>
            <li class="col-span-1 flex shadow-sm rounded-md">
              <div class="flex-shrink-0 flex items-center justify-center w-16 bg-pink-600 text-white text-sm font-medium rounded-l-md">
                <%= integration.provider %>
              </div>
              <div class="flex-1 flex items-center justify-between border-t border-r border-b border-gray-200 dark:border-gray-900 bg-white dark:bg-gray-800 rounded-r-md truncate">
                <div class="flex-1 px-4 py-2 text-sm truncate">
                  <a href={"/auth/#{integration.provider}/revoke"} class="text-red-900 dark:text-red-100 font-medium hover:text-red-600 dark:hover:text-red-400">
                    Revoke
                  </a>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>

      <div class="py-6">
        <h2 class="text-gray-500 dark:text-gray-300 text-sm font-medium">
          Add integrations
        </h2>
        <ul role="list" class="mt-3 grid grid-cols-1 gap-5 sm:gap-6 sm:grid-cols-2 lg:grid-cols-4">
          <%= for provider <- @providers do %>
            <li class="col-span-1 flex shadow-sm rounded-md">
              <div class="flex-shrink-0 flex items-center justify-center w-16 bg-gray-600 text-white text-sm font-medium rounded-l-md">
                <%= provider %>
              </div>
              <div class="flex-1 flex items-center justify-between border-t border-r border-b border-gray-200 dark:border-gray-900 bg-white dark:bg-gray-800 rounded-r-md truncate">
                <div class="flex-1 px-4 py-2 text-sm truncate">
                  <a href={"/auth/#{provider}"} class="text-brand-900 dark:text-brand-600 font-medium hover:text-brand-600 dark:hover:text-brand-400">
                    Add
                  </a>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
