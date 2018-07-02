defmodule HandyApiWeb.SourceController do
  use HandyApiWeb, :controller

  alias HandyApi.Logging.Source

  action_fallback(HandyApiWeb.FallbackController)

  def get_sources(conn, _params) do
    sources = ["a"]
    case Source.get_all() do
      {:ok, sources} -> render(conn, "index.json", sources: sources)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"500")
    end

  end

  def create(conn, %{"name" => name}) do
    source = %Source{name: name}
    case Source.create(source) do
      {:ok, new} ->
        IO.inspect(new)
        render(conn, "show.json", source: new)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end

  def show(conn, %{"id" => id}) do
    case Source.get(id) do
      {:ok, existing} ->
        IO.inspect(existing)
        render(conn, "show.json", source: existing)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end
end
