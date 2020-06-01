defmodule GSGMS.Repo do
  use Ecto.Repo,
    otp_app: :gsgms,
    adapter: Ecto.Adapters.Postgres
end
