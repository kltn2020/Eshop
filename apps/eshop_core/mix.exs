defmodule EshopCore.MixProject do
  use Mix.Project

  def project do
    [
      app: :eshop_core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {EshopCore.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:verk, "~> 1.0"},
      {:sentry, "~> 8.0"},
      {:hackney, "~> 1.16"},
      {:pow, "~> 1.0.22"},
      {:certifi, "~> 2.5.2"},
      {:ssl_verify_fun, "~> 1.1.6"},
      {:joken, "~> 2.3.0"},
      {:timex, "~> 3.6.2"},
      {:cloudex, "~> 1.4.1"},
      {:plug, "~> 1.0"},
      {:corsica, "~> 1.0"},
      {:elasticsearch, "~> 1.0.0"},
      {:tesla, "~> 1.4.0"},
      {:nanoid, "~> 2.0.5"},
      {:bamboo, "~> 1.7.0"},
      {:httpoison, "~> 1.8"},
      {:querie, github: "onpointvn/querie", branch: "v1"},
      {:tarams, github: "onpointvn/tarams", tag: "0.2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
