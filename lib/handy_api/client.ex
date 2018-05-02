defmodule HandyGrpcClient.Client do
  use GenServer
  def init(_args) do
    {:ok, state} = GRPC.Stub.connect("localhost:50051")
    GenServer.start_link(__MODULE__, state)
  end
  def handle_call({:create_source, }, from, state) do

  end

end
