import Config

config :eshop, Eshop.Repo,
  # ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :eshop, EshopWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :joken, default_signer: System.get_env("SECRET_JOKEN")

config :cloudex,
  api_key: System.get_env("CLOUDEX_API_KEY"),
  secret: System.get_env("CLOUDEX_SECRET"),
  cloud_name: System.get_env("CLOUDEX_CLOUD_NAME")

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
