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
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_args) do
    url = Application.get_env(:handy_api, :grpc_server_url)
    IO.puts("Trying to connect on: " <> url)
    {:ok, connect(url)}
  end

  def connect(url) do
    case GRPC.Stub.connect(url) do
      {:ok, channel} ->
        IO.puts("connected on " <> url)
        channel

      {:error, error} ->
        IO.puts("failed connection with #{inspect(error)}")
        :timer.sleep(1000)
        connect(url)
    end
  end

  @spec handle_call({:channel}, any, channel) :: any
  def handle_call({:channel}, _from, channel) do
    {:reply, {:ok, channel}, channel}
  end
  def handle_info({:gun_up,_,_}, state) do
    {:noreply, state}
  end
  def handle_info({:gun_down, _, _, _, _, _}, state) do
    {:noreply, state}
  end
end
