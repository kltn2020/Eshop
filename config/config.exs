use Mix.Config

config :eshop,
  ecto_repos: [Eshop.Repo]

# Configures the endpoint
config :eshop, EshopWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YZOHcbcMHsOvva3pf16hAqT/WfKikB+stgBInDmLB3x2YDDgUqXM/KyiblobCnDt",
  render_errors: [view: EshopWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Eshop.PubSub,
  live_view: [signing_salt: "zFeLlCrv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :eshop, :pow,
  user: Eshop.Identity.User,
  repo: Eshop.Repo

config :joken, default_signer: System.get_env("SECRET_JOKEN")

import_config "#{Mix.env()}.exs"
