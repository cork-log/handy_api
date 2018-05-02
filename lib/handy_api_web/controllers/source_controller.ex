defmodule HandyApiWeb.SourceController do
  use HandyApiWeb, :controller

  alias HandyApi.Logging
  alias HandyApi.Logging.Source

  action_fallback HandyApiWeb.FallbackController

  def index(conn, _params) do
    sources = ["a"]
    render(conn, "index.json", sources: sources)
  end

  def create(conn, %{"source" => source_params}) do
    source = nil
    render("show.json", source: source)
  end

  def show(conn, %{"id" => id}) do
    source = Logging.get_source!(id)
    render(conn, "show.json", source: source)
  end
end
