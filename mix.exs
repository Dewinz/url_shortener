defmodule UrlShortener.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :url_shortener,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {UrlShortener, []}
    ]
  end

  defp deps do
    [
      {:credo, ">= 0.0.0"},
      {:plug, ">= 0.0.0"},
      {:bandit, ">= 0.0.0"}
    ]
  end
end
