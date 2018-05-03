defmodule HandyApi.Api do
  alias HandyApi.Grpc
  def call(func) do
      channel = Grpc.Client.get_channel()
      func.(channel)
  end
end
