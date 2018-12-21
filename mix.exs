defmodule OpenStreetMap.MixProject do
  use Mix.Project

  @description """
    Integration with OpenStreetMap API
  """

  def project do
    [
      app: :open_street_map,
      version: "0.9.5",
      elixir: "~> 1.7",
      name: "OpenStreetMap",
      description: @description,
      source_url: "https://github.com/kortirso/open_street_map",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Anton Bogdanov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kortirso/open_street_map"}
    ]
  end
end
