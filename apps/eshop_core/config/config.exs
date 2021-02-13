use Mix.Config

config :eshop_core,
  ecto_repos: [EshopCore.Repo]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :eshop_core, :pow,
  user: EshopCore.Identity.User,
  repo: EshopCore.Repo

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

config :eshop_core, EshopCore.ES.Cluster,
  url: System.get_env("ELASTIC_HOST"),
  api: Elasticsearch.API.HTTP,
  json_library: Jason,
  indexes: %{
    products: %{
      settings: "priv/elasticsearch/products.json",
      store: EshopCore.ES.Product.Store,
      sources: [EshopCore.Ecom.Product],
      bulk_page_size: 5000,
      bulk_wait_interval: 15_000
    }
  }

import_config "#{Mix.env()}.exs"
