defmodule HandyApi.Logging.AuthContext do
  defstruct name: nil, enabled: nil, source_id: nil, id: nil
end

defmodule HandyApi.Logging.AuthContextService do
  alias HandyApi.Api
  alias HandyApi.Logging.AuthContext
  use Cartograf

  map(Proto.AuthContext, AuthContext, :to_context, auto: true) do
  end

  @spec get_auth_contexts(String) :: {:ok, AuthContext} | {:error}
  def get_auth_contexts(source_id) do
    Api.call(fn channel ->
      req = Proto.IdQuery.new(id: source_id)
      {:ok, stream} = Proto.LogSource.Stub.get_auth_contexts(channel, req)
      {:ok, Enum.map(stream, fn {:ok, context} -> to_context(context) end)}
    end)
  end

  @spec request_token(Map.t()) :: {:ok, String} | {:error}
  def request_token(%{context_id: auth_context_id}) do
    Api.call(fn channel ->
      req = Proto.IdQuery.new(id: auth_context_id)
      {:ok, resp} = Proto.LogSource.Stub.request_token(channel, req)
      {:ok, resp.token}
    end)
  end

  @spec create_auth_context(Map.t()) :: {:ok, AuthContext} | {:error}
  def create_auth_context(%{source_id: source, name: name}) do
    Api.call(fn channel ->
      req = Proto.NewAuthContext.new(source_id: source, name: name)
      {:ok, resp} = Proto.LogSource.Stub.create_auth_context(channel, req)
      {:ok, to_context(resp)}
    end)
  end

  @spec toggle_auth_context(Map.t()) :: {:ok, AuthContext} | {:error}
  def toggle_auth_context(%{context_id: context_id}) do
    Api.call(fn channel ->
      req = Proto.IdQuery.new(id: context_id)
      {:ok, resp} = Proto.LogSource.Stub.toggle_auth_context(channel, req)
      {:ok, to_context(resp)}
    end)
  end
end
