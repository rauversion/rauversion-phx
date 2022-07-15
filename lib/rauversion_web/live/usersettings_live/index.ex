defmodule RauversionWeb.UserSettingsLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end




end
