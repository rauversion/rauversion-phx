defmodule RauversionWeb.ProfileLive.Components.ArtistsList do
  use RauversionWeb, :live_component

  def get_artists(user) do
    user |> Ecto.assoc(:child_accounts) |> Rauversion.Repo.all()
  end

  def render(assigns) do
    ~H"""
    <div class="">
      <div class="mx-auto max-w-2xl py-16 px-4 sm:py-24 sm:px-6 lg:max-w-7xl lg:px-8">
        <div class="md:flex md:items-center md:justify-between">
          <h2 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-gray-200">
            Artists
          </h2>
          <!--<a
            href="#"
            class="hidden text-sm font-medium text-indigo-600 hover:text-indigo-500 md:block"
          >
            Shop the collection <span aria-hidden="true"> →</span>
          </a>-->
          <%= if @current_user.id == @profile.id do %>
            <.link
              patch="/accounts/connnect"
              class="inline-flex justify-between dark:border-2 dark:border-white rounded-lg py-3 px-5 bg-black text-white block font-medium"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                stroke-width="2"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"></path>
              </svg>
              <span>Add artist</span>
            </.link>
          <% end %>
        </div>

        <div class="mt-6 grid grid-cols-2 gap-x-4 gap-y-10 sm:gap-x-6 md:grid-cols-4 md:gap-y-0 lg:gap-x-8">
          <%= for artist <- get_artists(@current_user) do %>
            <div class="group relative">
              <div class="h-56 lg:h-72-- xl:h-80-- w-full overflow-hidden rounded-md bg-gray-200 group-hover:opacity-75">
                <%= img_tag(
                  Rauversion.Accounts.avatar_url(artist, :small),
                  class: "h-full w-full object-cover object-center"
                ) %>
              </div>

              <h3 class="mt-4 text-sm text-gray-700 dark:text-gray-300">
                <%= live_redirect(
                        to: Routes.profile_index_path(@socket, :index, artist.username)
                      ) do %>
                  <span class="absolute inset-0"></span> <%= artist.username %>
                <% end %>
              </h3>
            </div>
          <% end %>
        </div>

        <div class="mt-8 text-sm md:hidden">
          <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">
            Shop the collection <span aria-hidden="true"> →</span>
          </a>
        </div>
      </div>
    </div>
    """
  end
end
