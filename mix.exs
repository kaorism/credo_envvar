defmodule Credo.MixProject do
  use Mix.Project

  def project do
    [
      app: :credo_envvar,
      version: "0.1.4",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Add-on for Credo for checking environment variables that get evaluated at Elixir compile time.",
      package: package(),
      source_url: "https://github.com/kaorism/credo_envvar",
      name: "CredoEnvvar"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {CredoEnvvar.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 1.0", app: false, runtime: false}
    ]
  end

  defp package do
    [
      files: [
        "lib/credo_envvar/check/warning/environment_variables_at_compile_time.ex",
        "mix.exs",
        "README.md",
        "LICENSE"
      ],
      maintainers: ["Theesit Konkaew"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/kaorism/credo_envvar"
      }
    ]
  end
end
