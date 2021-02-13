defmodule EshopMailer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EshopMailerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EshopMailer.PubSub}
      # Start a worker by calling: EshopMailer.Worker.start_link(arg)
      # {EshopMailer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EshopMailer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EshopMailerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
