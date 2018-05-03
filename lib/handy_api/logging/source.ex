defmodule HandyApi.Logging.Source do
  alias HandyApi.Api
  alias __MODULE__
  defstruct id: nil, name: nil

  @spec from_proto(Proto.Source.t()) :: Source
  def from_proto(proto_source) do
    %Source{name: proto_source.name, id: proto_source.id}
  end

  @spec create(Source) :: {:ok, Source} | {:error}
  def create(source) do
    Api.call(fn channel ->
      req = Proto.NewSource.new(name: source.name)
      {:ok, resp} = Proto.LogSource.Stub.create(channel, req)
      {:ok, from_proto(resp)}
    end)
  end

  @spec get(String) :: {:ok, Source} | {:error}
  def get(id) do
    Api.call(fn channel ->
      req = Proto.IdQuery.new(id: id)
      {:ok, resp} = Proto.LogSource.Stub.get(channel, req)
      IO.inspect(resp)
      {:ok, from_proto(resp)}
    end)
  end

end
