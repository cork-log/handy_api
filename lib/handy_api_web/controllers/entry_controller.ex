defmodule HandyApiWeb.EntryController do
  use HandyApiWeb, :controller
  alias HandyApi.Logging.Entry

  action_fallback(HandyApiWeb.FallbackController)

  def index(conn, _params) do
    log_entries = nil
    render(conn, "index.json", log_entries: log_entries)
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
