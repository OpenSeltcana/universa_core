defmodule UniversaCore.Mixfile do
  use Mix.Project

  def project do
    [
      app: :universa_core,
      version: "0.1.0",
      elixir: "~> 1.5",
			build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
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
			mod: {Universa.Core, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
			{:ex_doc, "~> 0.16", only: :dev, runtime: false},
			{:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false}
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
