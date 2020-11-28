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
  metadata: [:request_id],
  backends: [:console, Sentry.LoggerBackend]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :eshop, :pow,
  user: Eshop.Identity.User,
  repo: Eshop.Repo

config :joken, default_signer: System.get_env("SECRET_JOKEN")

config :cloudex,
  api_key: System.get_env("CLOUDEX_API_KEY"),
  secret: System.get_env("CLOUDEX_SECRET"),
  cloud_name: System.get_env("CLOUDEX_CLOUD_NAME")

config :sentry,
  dsn: {:system, "SENTRY_DSN"},
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: System.get_env("SENTRY_RELEASE_LEVEL")
  },
  included_environments: ~w(prod),
  environment_name: Mix.env()

config :eshop, Eshop.ES.Cluster,
  url: System.get_env("ELASTIC_HOST"),
  api: Elasticsearch.API.HTTP,
  json_library: Jason,
  indexes: %{
    products: %{
      settings: "priv/elasticsearch/products.json",
      store: Eshop.ES.Product.Store,
      sources: [Eshop.Ecom.Product],
      bulk_page_size: 5000,
      bulk_wait_interval: 15_000
    }
  }

import_config "#{Mix.env()}.exs"
