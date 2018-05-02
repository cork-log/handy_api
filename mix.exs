defmodule HandyApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :handy_api,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HandyApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, git: "https://github.com/phoenixframework/phoenix", branch: "master", override: true},
      {:plug, git: "https://github.com/elixir-plug/plug", branch: "master", override: true},
      # {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:grpc, git: "https://github.com/tony612/grpc-elixir.git"},
      {:cowboy, "~> 2.0", override: true}
    ]
  end
end
