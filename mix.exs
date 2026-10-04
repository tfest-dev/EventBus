defmodule Eventbus.MixProject do
  use Mix.Project

  def project do
    [
      app: :eventbus,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Eventbus.CLI, path: "eventbus", app: nil],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:inets, :logger],
      mod: {Eventbus.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.7"}
    ]
  end
end
