defmodule Extensor.MixProject do
  use Mix.Project

  def project do
    [
      app: :extensor,
      name: "Extensor",
      version: "0.1.1",
      elixir: "~> 1.6",
      compilers: ["nif" | Mix.compilers()],
      aliases: [clean: ["clean", "clean.nif"]],
      description: description(),
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.post": :test
      ],
      dialyzer: [
        ignore_warnings: ".dialyzerignore",
        plt_add_deps: :transitive
      ],
      docs: [extras: ["README.md"]]
    ]
  end

  defp description do
    """
    Tensorflow bindings for inference in Elixir.
    """
  end

  defp deps do
    [
      {:protobuf, "~> 0.5.3"},
      {:google_protos, "~> 0.1"},
      {:excoveralls, "~> 0.8", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:benchee, "~> 0.9", only: :dev, runtime: false},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: [
        "mix.exs",
        "README.md",
        "lib",
        "c_src/**/{*.c,*.cpp,*.h,*.hpp,Makefile,*.makefile}",
        "priv/.gitignore"
      ],
      maintainers: ["Brent M. Spell"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/pylon/extensor",
        "Docs" => "http://hexdocs.pm/extensor/"
      }
    ]
  end
end

defmodule Mix.Tasks.Compile.Nif do
  def run(_args) do
    {result, 0} = System.cmd("make", ["-C", "c_src"])
    IO.binwrite(result)
  end
end

defmodule Mix.Tasks.Clean.Nif do
  def run(_args) do
    {result, 0} = System.cmd("make", ["-C", "c_src", "clean"])
    IO.binwrite(result)
  end
end
