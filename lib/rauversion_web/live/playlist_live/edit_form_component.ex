defmodule RauversionWeb.PlaylistLive.EditFormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""

    <div class="space-y-8 divide-y divide-gray-200 sm:space-y-5">
      <.form
      let={f}
      for={@changeset}
      id="playlist-form"
      phx-target={@myself}
      phx-change="validate"
      phx-submit="save">

      <%= label f, :slug %>
      <%= text_input f, :slug %>
      <%= error_tag f, :slug %>

      <%= label f, :description %>
      <%= textarea f, :description %>
      <%= error_tag f, :description %>

      <%= label f, :title %>
      <%= text_input f, :title %>
      <%= error_tag f, :title %>

      <%= label f, :metadata %>
      <%= text_input f, :metadata %>
      <%= error_tag f, :metadata %>

      <div>
        <%= submit "Save", phx_disable_with: "Saving..." %>
      </div>
    </.form>
    </div>

    """
  end
end
