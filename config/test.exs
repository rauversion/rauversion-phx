import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

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
  timeout: 300_000_000

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rauversion, RauversionWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "asD6uWDumjqKv0TC2V9kMI3/1Vb/t+4I/rDC9qygryTac4Zcc7Dx/gmlQCui+s/s",
  server: false

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
