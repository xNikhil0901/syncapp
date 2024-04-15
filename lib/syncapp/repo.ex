defmodule Syncapp.Repo do
  use Ecto.Repo,
    otp_app: :syncapp,
    adapter: Ecto.Adapters.Postgres
end
