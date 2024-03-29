defmodule Qencode.MixProject do
  use Mix.Project
  @github_url "https://github.com/char0n/qencode"

  def project do
    [
      app: :qencode,
      version: "0.4.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      files: ~w(mix.exs lib LICENSE.md README.md CHANGELOG.md .formatter.exs),
      package: [
        maintainers: ["Vladimír Gorej"],
        licenses: ["BSD-3-Clause"],
        links: %{
          "GitHub" => @github_url
        }
      ],
      # Docs
      name: "Qencode",
      source_url: @github_url,
      homepage_url: "https://hexdocs.pm/qencode/",
      description:
        "Full featured video transcoding using the Qencode API that can be easily modified for your website or application.",
      docs: [
        # The main page in the docs
        main: "readme",
        extras: ["README.md", "CHANGELOG.md", "LICENSE.md"]
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.circle": :test
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
      {:ex_doc, "~> 0.19", only: [:dev, :test], runtime: false},
      {:git_ops, "~> 0.6.0", only: [:dev]},
      {:jason, "~> 1.1"},
      {:excoveralls, "~> 0.10", only: :test},
      {:junit_formatter, "~> 3.0", only: [:dev, :test]}
    ]
  end
end
