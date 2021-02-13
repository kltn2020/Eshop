defmodule EshopAdmin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EshopAdminWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EshopAdmin.PubSub},
      # Start the Endpoint (http/https)
      EshopAdminWeb.Endpoint
      # Start a worker by calling: EshopAdmin.Worker.start_link(arg)
      # {EshopAdmin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EshopAdmin.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
