defmodule RauversionWeb.UserSettingsLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Accounts
  alias RauversionWeb.UserAuth

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def update(_params, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event(action, params, socket) do
    IO.puts("UNHANDLED action = #{inspect(action)}")
    IO.puts("UNHANDLED params = #{inspect(params)}")
    {:noreply, socket}
  end



end
