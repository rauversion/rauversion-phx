defmodule RauversionWeb.ProfileLive.MenuComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(%{data: _data} = assigns) do
    ~H"""
    <div class="relative bg-white">
    <div class="absolute inset-0 shadow z-30 pointer-events-none" aria-hidden="true"></div>
    <div class="z-20 sticky top-0">
      <div class="max-w-7xl mx-auto flex justify-between items-center px-4 py-5 sm:px-6 sm:py-4 lg:px-8 md:justify-start md:space-x-10">

        <div class="hidden md:flex-1 md:flex md:items-center md:justify-between">
          <nav class="flex space-x-10">
            <%= for %{name: name, url: url, selected: selected, kind: kind} <- assigns.data do %>
              <% #= selected %>
              <% #= kind %>
              <%= live_patch name, to: url, class: "text-base font-medium #{if selected do "border-b border-b-4 text-gray-800 hover:text-gray-900 border-orange-500 " else "text-gray-500 hover:text-gray-900" end}" %>
            <% end %>
          </nav>
          <div class="flex items-center md:ml-12">
            <a href="#" class="text-base font-medium text-gray-500 hover:text-gray-900"> Your insights </a>
            <a href="#" class="ml-8 inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-gray-600 hover:bg-gray-700"> Edit profile </a>
          </div>
        </div>
      </div>
    </div>
    </div>
    """
  end
end
