defmodule Eshop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Eshop.Repo,
      # Start the Telemetry supervisor
      EshopWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Eshop.PubSub},
      # Start the Endpoint (http/https)
      EshopWeb.Endpoint,
      Eshop.ES.Cluster
      # Start a worker by calling: Eshop.Worker.start_link(arg)
      # {Eshop.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Eshop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EshopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
