defmodule WemosErgo.Repo do
  use Ecto.Repo,
    otp_app: :wemos_ergo,
    adapter: Ecto.Adapters.Postgres
end
