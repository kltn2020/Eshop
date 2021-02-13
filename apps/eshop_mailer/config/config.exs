use Mix.Config

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :eshop_mailer, EshopMailerWeb.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: {:system, "SENDGRID_API_KEY"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
