defmodule Rauversion.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # unless Mix.env() == :prod do
    #  Dotenv.load()
    #  Mix.Task.run("loadconfig")
    # end
    Logger.add_backend(Sentry.LoggerBackend)

    children = [
      # Start the Ecto repository
      Rauversion.Repo,
      # Start the Telemetry supervisor
      RauversionWeb.Telemetry,
      Rauversion.TrackingEvents.WriteBuffer,
      {Oban, Application.fetch_env!(:rauversion, Oban)},
      # Start the PubSub system
      {Phoenix.PubSub, name: Rauversion.PubSub},
      # Start the Endpoint (http/https)
      RauversionWeb.Endpoint
      # Start a worker by calling: Rauversion.Worker.start_link(arg)
      # {Rauversion.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rauversion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RauversionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
