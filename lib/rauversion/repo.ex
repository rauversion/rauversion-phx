defmodule Rauversion.Repo do
  use Ecto.Repo,
    otp_app: :rauversion,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
