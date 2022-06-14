defmodule Rauversion.Repo do
  use Ecto.Repo,
    otp_app: :rauversion,
    adapter: Ecto.Adapters.Postgres
end
