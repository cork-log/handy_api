defmodule HandyApi.Logging.Source do
  alias HandyApi.Api
  alias HandyApi.Logging.AuthContextService
  alias __MODULE__
  defstruct id: nil, name: nil, contexts: []

  @spec from_proto(Proto.Source.t()) :: Source
  def from_proto(proto_source) do
    %Source{name: proto_source.name, id: proto_source.id, contexts: Enum.map(proto_source.contexts, &AuthContextService.to_context/1)}
  end

  def get_all() do
    Api.call(fn channel ->
      req = Proto.Empty.new()

      case Proto.LogSource.Stub.get_sources(channel, req) do
        {:ok, stream} -> {:ok, Enum.map(stream, fn {:ok, entry} -> entry end)}
        {:error, _} -> {:error}
      end
    end)
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
