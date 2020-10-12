defmodule Extensor.MixProject do
  use Mix.Project

  def project do
    [
      app: :extensor,
      name: "Extensor",
      version: "2.3.2",
      elixir: "~> 1.9",
      compilers: [:elixir_make] ++ Mix.compilers(),
      make_cwd: "c_src",
      make_clean: ["clean"],
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
      {:protobuf, "~> 0.7"},
      {:google_protos, "~> 0.1"},
      {:matrex, "~> 0.6", optional: true},
      {:excoveralls, "~> 0.12", only: :test},
      {:elixir_make, "~> 0.6", runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:benchee, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
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
