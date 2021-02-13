use Mix.Config

config :eshop_client, EshopClientWeb.Endpoint,
  url: [host: "example.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

# Do not print debug messages in production
config :logger, level: :info

config :eshop_client, EshopClientWeb.Endpoint, server: true
