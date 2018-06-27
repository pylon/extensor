defmodule Extensor.MixProject do
  use Mix.Project

  def project do
    [
      app: :extensor,
      name: "Extensor",
      version: "0.1.3",
      elixir: "~> 1.6",
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
      {:protobuf, "~> 0.5.3"},
      {:google_protos, "~> 0.1"},
      {:matrex, "~> 0.6", optional: true},
      {:excoveralls, "~> 0.8", only: :test},
      {:elixir_make, "~> 0.4", runtime: false},
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
