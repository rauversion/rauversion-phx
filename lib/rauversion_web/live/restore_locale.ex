defmodule RauversionWeb.RestoreLocale do
  # import Phoenix.LiveView

  def on_mount(:default, _params, %{"locale" => locale} = _session, socket) do
    Gettext.put_locale(RauversionWeb.Gettext, locale)
    {:cont, socket}
  end

  # for any logged out routes
  def on_mount(:default, _params, _session, socket), do: {:cont, socket}
end
