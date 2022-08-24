import Config

unless Mix.env() == :prod do
  Dotenv.load!()
end

config :active_storage, :services,
  amazon: [
    service: "S3",
    bucket: System.get_env("AWS_S3_BUCKET"),
    access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
    secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
    region: System.get_env("AWS_S3_REGION"),
    # scheme: "https://",
    # host: "localhost",
    # port: 9000,
    force_path_style: true
  ],
  minio: [
    service: "S3",
    bucket: "active-storage-test",
    access_key_id: "root",
    secret_access_key: "active_storage_test",
    scheme: "http://",
    host: "localhost",
    port: 9000,
    force_path_style: true
  ],
  local: [service: "Disk", root: Path.join(File.cwd!(), "tmp/storage")],
  local_public: [service: "Disk", root: Path.join(File.cwd!(), "tmp/storage"), public: true],
  test: [
    service: "Disk",
    root: "tmp/storage"
  ]

config :rauversion, google_maps_key: System.get_env("GOOGLE_MAPS_KEY")

config :rauversion, disabled_registrations: System.get_env("DISABLED_REGISTRATIONS", "false")

config :ueberauth, Ueberauth.Strategy.Zoom.OAuth,
  client_id: System.get_env("ZOOM_CLIENT_ID"),
  client_secret: System.get_env("ZOOM_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  client_id: System.get_env("TWITTER_CLIENT_ID"),
  client_secret: System.get_env("TWITTER_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
  client_id: System.get_env("DISCORD_CLIENT_ID"),
  client_secret: System.get_env("DISCORD_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Stripe.OAuth,
  client_id: System.get_env("STRIPE_CLIENT_ID"),
  client_secret: System.get_env("STRIPE_CLIENT_SECRET")

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :rauversion, Rauversion.Repo,
    ssl: true,
    # socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :active_storage, :secret_key_base, secret_key_base

  config :rauversion, RauversionWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :rauversion, RauversionWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :rauversion, Rauversion.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.

  config :rauversion, Rauversion.Mailer,
    adapter: Swoosh.Adapters.SMTP,
    relay: System.get_env("SMTP_DOMAIN"),
    username: System.get_env("SMTP_USERNAME"),
    password: System.get_env("SMTP_PASSWORD"),
    # ssl: true,
    # tls: :always,
    auth: :always,
    port: 587,
    # dkim: [
    #  s: "default", d: "domain.com",
    #  private_key: {:pem_plain, File.read!("priv/keys/domain.private")}
    # ],
    retries: 2,
    no_mx_lookups: false
end
