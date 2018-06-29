defmodule HandyApi.Grpc.Client do
  use GenServer
  alias HandyApi.Logging

  # Public Impl
  def get_channel() do
    {:ok, channel} = GenServer.call(__MODULE__, {:channel})
    channel
  end

  def init(args) do
    {:ok, args}
  end

  # Private Impl
  @type channel :: GRPC.Channel.t()
  def start_link() do
    url = Application.get_env(:handy_api, :grpc_server_url)
    IO.puts("Trying to connect on: " <> url)
    # case GRPC.Stub.connect("gateway:50051") do
    connect(url)
  end

  def connect(url) do
    case GRPC.Stub.connect(url) do
      {:ok, channel} ->
        IO.puts("connected on " <> url)
        GenServer.start_link(__MODULE__, channel, name: __MODULE__)

      {:error, error} ->
        IO.puts("failed connection with #{inspect(error)}, \n retrying:\n")
        :timer.sleep(1000)
        connect(url)
    end
  end

  @spec handle_call({:channel}, any, channel) :: any
  def handle_call({:channel}, _from, channel) do
    {:reply, {:ok, channel}, channel}
  end
end
