defmodule Qencode.MixProject do
  use Mix.Project

  def project do
    [
      app: :qencode,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "Qencode",
      source_url: "https://github.com/char0n/qencode",
      homepage_url: "https://github.com/char0n/qencode",
      docs: [
        # The main page in the docs
        main: "readme",
        extras: ["README.md", "CHANGELOG.md", "LICENSE.md"]
      ]
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.4", only: [:dev, :test], runtime: false},
      {:castore, "~> 0.1.0"},
      {:simplehttp, "~> 0.5.1", runtime: true},
      {:poison, "~> 4.0", runtime: true},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:git_ops, "~> 0.6.0", only: [:dev]}
    ]
  end
end
