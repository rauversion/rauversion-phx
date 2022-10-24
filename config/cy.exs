import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

config :rauversion, RauversionWeb.Gettext, locales: ~w(en es pt), default_locale: "en"

config :ex_cldr,
  default_locale: "en",
  default_backend: Rauversion.Cldr,
  json_library: Jason

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rauversion, Rauversion.Repo,
  username: "postgres",
  password: "postgres",
  database: "rauversion_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DB_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  ownership_timeout: 300_000_000,
  timeout: 300_000_000,
  stacktrace: true

config :rauversion, :domain, System.get_env("HOST", "http://localhost:4000")
config :rauversion, :app_name, System.get_env("APP_NAME", "rauversion")

if System.get_env("GITHUB_ACTIONS") do
  config :rauversion, Rauversion.Repo,
    username: "postgres",
    password: "postgres"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rauversion, RauversionWeb.Endpoint,
  secret_key_base: "asD6uWDumjqKv0TC2V9kMI3/1Vb/t+4I/rDC9qygryTac4Zcc7Dx/gmlQCui+s/s",
  http: [ip: {0, 0, 0, 0}, port: 4002],
  check_origin: false,
  code_reloader: true,
  debug_errors: true

# watchers: [
#  tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]},
#  # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
#  esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
# ]

# In test we don't send emails.
config :rauversion, Rauversion.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# :amazon
config :active_storage, :service, :local
config :active_storage, :secret_key_base, "xxxxxxxxxxx"
config :active_job, repo: Rauversion.Repo
config :active_storage, repo: Rauversion.Repo

# config :rauversion, Oban, testing: :inline

config :rauversion, Oban,
  repo: Rauversion.Repo,
  queues: false,
  crontab: false,
  plugins: false,
  testing: :inline
