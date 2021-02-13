defmodule EshopClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EshopClientWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EshopClient.PubSub},
      # Start the Endpoint (http/https)
      EshopClientWeb.Endpoint
      # Start a worker by calling: EshopClient.Worker.start_link(arg)
      # {EshopClient.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EshopClient.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EshopClientWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
