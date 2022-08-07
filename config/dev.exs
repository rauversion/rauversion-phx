import Config

# Configure your database
config :rauversion, Rauversion.Repo,
  username: "postgres",
  password: "postgres",
  database: "rauversion_phx_dev",
  hostname: System.get_env("DB_HOST", "localhost"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  stacktrace: true

config :rauversion, :domain, System.get_env("HOST", "https://rauversion.com")

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :rauversion, RauversionWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "Ga6651EYCdxFIUDx0VnhDKFE4Kc5uyekmzY5nLG8yYxUgYpjhv0Rzm1Z4CJkeylZ",
  watchers: [
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]},
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :rauversion, RauversionWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/rauversion_web/(live|views)/.*(ex)$",
      ~r"lib/rauversion_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console,
  format: "[$level] $message\n",
  truncate: :infinity

config :logger, level: :debug

config :rauversion, :app_name, "Rauversion.com"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :rauversion, Oban,
  repo: Rauversion.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, events: 50, media: 20]

# activestorage

# :amazon
config :active_storage, :host, "http://localhost:4000"
config :active_storage, :service, :amazon
config :active_storage, :secret_key_base, "xxxxxxxxxxx"
config :active_job, repo: Rauversion.Repo
config :active_storage, repo: Rauversion.Repo

config :mogrify,
  mogrify_command: [
    path: "mogrify",
    args: []
  ]

# Configure convert command:

config :mogrify,
  convert_command: [
    path: "convert",
    args: []
  ]

# Configure identify command:

config :mogrify,
  identify_command: [
    path: "identify",
    args: ["-verbose"]
  ]
