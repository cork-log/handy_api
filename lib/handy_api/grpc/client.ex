defmodule HandyApi.Grpc.Client do
  use GenServer
  alias HandyApi.Logging

  # Public Impl
  def get_channel() do
    {:ok, channel} = GenServer.call(__MODULE__, {:channel})
    channel
  end

  # Private Impl
  @type channel :: GRPC.Channel.t()
  def start_link() do
    url = Application.get_env(:handy_api, :grpc_server_url)
    IO.puts("Trying to connect on: " <> url)
    # case GRPC.Stub.connect("gateway:50051") do
    case GRPC.Stub.connect(url) do
      {:ok, state} -> GenServer.start_link(__MODULE__, state, name: __MODULE__)
      {:error, error} -> {:error, error <> " :: url(#{url})"}
    end
  end

  @spec handle_call({:channel}, any, channel) :: any
  def handle_call({:channel}, _from, channel) do
    {:reply, {:ok, channel}, channel}
  end
end
