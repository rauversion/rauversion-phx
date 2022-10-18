# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :rauversion,
  ecto_repos: [Rauversion.Repo]

# Configures the endpoint
config :rauversion, RauversionWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RauversionWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Rauversion.PubSub,
  live_view: [signing_salt: "WyVJIKVd"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :rauversion, Rauversion.Mailer, adapter: Swoosh.Adapters.Local

# https://lokalise.com/blog/localization-of-phoenix-applications/
config :rauversion, RauversionWeb.Gettext, locales: ~w(en es pt), default_locale: "es"

config :ex_cldr,
  default_locale: "es",
  default_backend: Rauversion.Cldr,
  json_library: Jason

config :ueberauth, Ueberauth,
  providers: [
    zoom: {Ueberauth.Strategy.Zoom, [ignores_csrf_attack: true]},
    twitter: {Ueberauth.Strategy.Twitter, [ignores_csrf_attack: true]},
    discord: {Ueberauth.Strategy.Discord, [ignores_csrf_attack: true]},
    stripe: {Ueberauth.Strategy.Stripe, [ignores_csrf_attack: true]},
    twitch: {Ueberauth.Strategy.Twitch, [ignores_csrf_attack: true]}
    # facebook: { Ueberauth.Strategy.Facebook, [ opt1: "value", opts2: "value" ] },
    # github: { Ueberauth.Strategy.Github, [ opt1: "value", opts2: "value" ] }
  ]

# data_dir: "./priv/cldr",
# force_locale_download: Mix.env() == :prod

# cacertfile: "path/to/cacertfile"

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.0.24",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  truncate: :infinity

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_meta_tags,
  title: "Rauversion",
  description:
    "Rauversion is an open source platforms to build communities of musicians, podcasters and listeners. Is a self-hosted streaming music service owned by the people that use it – musicians, indie labels, fans + developers.",
  url: "https://rauversion.com",
  # image: "https://phoenix.meta.tags.default/logo.png",
  "og:text": "Rauversion"

# config :rauversion, Oban,
#  repo: Rauversion.Repo,
#  plugins: [Oban.Plugins.Pruner],
#  queues: [default: 10]

config :mime, :types, %{
  "audio/ogg" => ["ogg"]
}

# fb: %{
#   name: "facebook",
#   size: %{
#     width: 100,
#     height: 200,
#     position: %{
#       x: 10,
#       y: 15
#     }
#   }
# }

# 30 mins
config :geoip, cache_ttl_secs: 1800
config :geoip, provider: :ipinfo, api_key: System.get_env("IP_INFO_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
