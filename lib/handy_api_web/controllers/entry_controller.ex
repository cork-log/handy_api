defmodule HandyApiWeb.EntryController do
  use HandyApiWeb, :controller
  alias HandyApi.Logging.Entry

  action_fallback(HandyApiWeb.FallbackController)

  def get_entries(conn, %{"source_id" => source_id} = params) do
    {take, _} = Integer.parse(Map.get(params, "take", "50"))
    {direction, _} = Integer.parse(Map.get(params, "direction", "0"))
    last = Map.get(params, "last_timestamp", "")

    case Entry.get_n(source_id, %{take: take, direction: direction, last_timestamp: last}) do
      {:ok, log_entries} -> render(conn, "index.json", log_entries: log_entries)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end

  def insert(conn, %{
        "source_id" => source_id,
        "level" => lvl,
        "content" => content,
        "tag" => tag,
        "timestamp_occurred" => ts
      }) do
    new_entry = %Entry{
      source_id: source_id,
      level: lvl,
      content: content,
      tag: tag,
      timestamp_occurred: ts
    }
    IO.inspect(new_entry)
    case Entry.insert(new_entry) do
      {:ok, entry} -> render(conn, "show.json", entry: entry)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end
end
