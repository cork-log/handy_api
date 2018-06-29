defmodule HandyApi.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(HandyApiWeb.Endpoint, []),
      supervisor(HandyApi.Grpc.Client, [], restart: :permanent),
      {Task.Supervisor, name: HandyApi.SocketSupervisor},
      # Supervisor.child_spec(
      #   {Task.Supervisor, name: HandyApi.SocketSupervisor},
      #   id: :socket_supervisor
      # ),
      {Task, fn -> HandyApi.TcpServer.accept(4545) end}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HandyApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HandyApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
