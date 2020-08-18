import Config

database_url = System.get_env("DATABASE_URL")

config :eshop, Eshop.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base = System.get_env("SECRET_KEY_BASE")

config :eshop, EshopWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base
