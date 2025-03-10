defmodule Charm.Repo do
  use Ecto.Repo,
    otp_app: :charm,
    adapter: Ecto.Adapters.Postgres
end
