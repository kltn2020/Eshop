defmodule Eshop.Repo do
  use Ecto.Repo,
    otp_app: :eshop,
    adapter: Ecto.Adapters.Postgres
end
