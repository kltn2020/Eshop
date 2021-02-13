defmodule EshopWorker.MixProject do
  use Mix.Project

  def project do
    [
      app: :eshop_worker,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EshopWorker.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:eshop_mailer, in_umbrella: true},
      {:eshop_core, in_umbrella: true}
    ]
  end
end
