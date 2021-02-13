defmodule EshopCore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Redix, {System.get_env("REDIS_URL"), [name: :redix_api]}},
      # Start the Ecto repository
      EshopCore.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: EshopCore.PubSub},
      EshopCore.ES.Cluster
    ]

    update_elasticsearch_config()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EshopCore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp update_elasticsearch_config do
    elastic_settings =
      Application.get_env(:eshop_core, EshopCore.ES.Cluster)
      |> update_settings_file_path()

    Application.put_env(:eshop_core, EshopCore.ES.Cluster, elastic_settings)
  end

  defp update_settings_file_path(conf) do
    path = Path.join(:code.priv_dir(:eshop_core), "/elasticsearch/products.json")

    put_in(conf, [:indexes, :products, :settings], path)
  end
end
