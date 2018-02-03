defmodule UniversaEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :universa_core,
      version: "0.2.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
			description: description(),
			package: package(),
			name: "Universa Core",
			source_url: "https://github.com/OpenSeltcana/universa_core",
			docs: [main: "Universa Core",
						 extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Universa.Core.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"}, #For entity UUID generation
      {:yaml_elixir, "~> 1.3.1"}, #For reading and writing YAML files
      {:poison, "~> 3.1"}, #For converting from/to JSONB

			{:ecto, "~> 2.0"}, #Database wrapper
			{:postgrex, "~> 0.11"} #Postgresql interface
    ]
  end

  defp description do
		"""
		Universa is the MUD codebase of the future! This Core package provides the Entity and the Network modules.
		"""
	end

  defp package do
		[
			name: "universa_core",
			files: ["lib", "mix.exs", "README.md", "LICENSE"],
			maintainers: ["FaztSquirrel", "Brian Hodgins"],
			licenses: ["BSD-3-Clause"],
			links: %{"GitHub" => "https://github.com/OpenSeltcana/universa_core"}
		]
	end
end
