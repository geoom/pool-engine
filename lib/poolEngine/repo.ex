defmodule PoolEngine.Repo do
  use Ecto.Repo,
    otp_app: :poolEngine,
    adapter: Ecto.Adapters.Postgres
end
