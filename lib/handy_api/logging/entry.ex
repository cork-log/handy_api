defmodule HandyApi.Logging.Entry do
  alias HandyApi.Api
  alias __MODULE__

  defstruct id: nil,
            source_id: nil,
            level: nil,
            tag: nil,
            content: nil,
            timestamp_occurred: nil,
            timestamp_stored: nil

  @spec from_proto(Proto.LogEntry) :: Entry
  def from_proto(proto) do
    struct(Entry, Map.from_struct(proto))
  end

  def get_n(source_id, query) do
    Api.call(fn channel ->
      query = Proto.PageQuery.new(query)
      req = Proto.EntryQuery.new(%{source_id: source_id, query: query})

      case Proto.LogEntry.Stub.get_n(channel, req) do
        {:ok, stream} -> {:ok, Enum.map(stream, fn {:ok, entry} -> entry end)}
        {:error, _} -> {:error}
      end
    end)
  end

  def insert(entry) do
    IO.inspect(entry)

    Api.call(fn channel ->
      req = Proto.NewEntry.new(Map.from_struct(entry))
      {:ok, entry} = Proto.LogEntry.Stub.insert(channel, req)
      {:ok, from_proto(entry)}
    end)
  end
end
