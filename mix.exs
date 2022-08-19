defmodule Rauversion.MixProject do
  use Mix.Project

  def project do
    [
      app: :rauversion,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      # ++ [:cldr],
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Rauversion.Application, []},
      extra_applications: [:ex_cldr, :logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.6.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.8"},
      {:postgrex, ">= 0.0.0"},
      {:ecto_psql_extras, "~> 0.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.0"},
      {:floki, ">= 0.30.0", override: true},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:faker, "~> 0.17", only: [:test, :dev]},
      {:ecto_autoslug_field, "~> 3.0"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]},
      {:scrivener_ecto, "~> 2.0"},
      {:gen_smtp, "~> 1.2.0"},
      {:simplex_format, "0.2.0"},
      {:phoenix_meta_tags, "~> 0.1.9"},
      {:geoip, "~> 0.2"},
      {:remote_ip, "~> 1.0"},
      {:countries, "~> 1.6"},
      {:browser, "~> 0.4.4"},
      {:timex, "~> 3.0"},
      {:oban, "~> 2.13"},
      {:fsmx, "~> 0.2.0"},
      {:oembed, "~> 0.4.1"},
      {:tesla, "~> 1.4"},
      {:ex_cldr_dates_times, "~> 2.0"},
      {
        :active_storage,
        git: "https://github.com/chaskiq/ex-rails.git",
        sparse: "apps/active_storage",
        branch: "skip-oban-config"
      },
      {
        :active_job,
        git: "https://github.com/chaskiq/ex-rails.git",
        sparse: "apps/active_job",
        override: true,
        branch: "skip-oban-config"
      }
      # {
      #  :active_job,
      #  "0.1.1"
      # }
      # {:active_storage,
      # path: "/Users/michelson/Documents/chaskiq/chaskiq-phoenix/ex_rails/apps/active_storage"
      # }
      # {:active_job,
      # path: "/Users/michelson/Documents/chaskiq/chaskiq-phoenix/ex_rails/apps/active_job",
      # override: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      # "assets.deploy": ["esbuild default --minify", "phx.digest"]
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
