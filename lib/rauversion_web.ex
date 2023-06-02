defmodule RauversionWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use RauversionWeb, :controller
      use RauversionWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt sitemaps)

  def controller do
    quote do
      use Phoenix.Controller, namespace: RauversionWeb
      use PhoenixMetaTags.TagController
      import Plug.Conn
      import RauversionWeb.Gettext
      alias RauversionWeb.Router.Helpers, as: Routes
      unquote(verified_routes())
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/rauversion_web/templates",
        namespace: RauversionWeb

      use PhoenixMetaTags.TagView
      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {RauversionWeb.LayoutView, :live}

      use PhoenixMetaTags.TagController

      use PhoenixMetaTags.TagView

      on_mount RauversionWeb.RestoreLocale
      alias RauversionWeb.Router.Helpers, as: Routes

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import RauversionWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers
      import Phoenix.Component
      import RauversionWeb.LiveHelpers
      import PolymorphicEmbed.HTML.Form

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import RauversionWeb.ErrorHelpers
      import RauversionWeb.Gettext
      alias RauversionWeb.Router.Helpers, as: Routes
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: RauversionWeb.Endpoint,
        router: RauversionWeb.Router,
        statics: RauversionWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
