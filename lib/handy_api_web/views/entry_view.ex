defmodule HandyApiWeb.EntryView do
  use HandyApiWeb, :view
  alias HandyApiWeb.EntryView

  def render("index.json", %{log_entries: log_entries}) do
    %{data: render_many(log_entries, EntryView, "entry.json")}
  end

  def render("show.json", %{entry: entry}) do
    %{data: render_one(entry, EntryView, "entry.json")}
  end

  def render("entry.json", %{entry: entry}) do
    %{
      id: entry.id,
      source_id: entry.source_id,
      content: entry.content,
      tag: entry.tag,
      level: entry.level,
      timestamp_occurred: entry.timestamp_occurred,
      timestamp_stored: entry.timestamp_stored
    }
  end
end
