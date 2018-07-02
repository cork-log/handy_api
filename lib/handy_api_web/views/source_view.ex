defmodule HandyApiWeb.SourceView do
  use HandyApiWeb, :view
  alias HandyApiWeb.SourceView

  def render("index.json", %{sources: sources}) do
    render_many(sources, SourceView, "source.json")
  end

  def render("show.json", %{source: source}) do
    render_one(source, SourceView, "source.json")
  end

  def render("source.json", %{source: source}) do
    %{id: source.id, name: source.name}
  end
end
