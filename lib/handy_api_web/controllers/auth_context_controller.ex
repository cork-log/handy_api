defmodule HandyApiWeb.AuthContextController do
  use HandyApiWeb, :controller
  alias HandyApi.Logging.AuthContextService

  action_fallback(HandyApiWeb.FallbackController)

  def get_contexts(conn, %{"source_id" => source_id} = _params) do
    case AuthContextService.get_auth_contexts(source_id) do
      {:ok, contexts} -> render(conn, "index.json", auth_contexts: contexts)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end

  def insert(conn, %{"name" => name, "source_id" => source_id}) do
    case AuthContextService.create_auth_context(%{source_id: source_id, name: name}) do
      {:ok, context} -> render(conn, "show.json", auth_context: context)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end

  def request_token(conn, %{"source_id" => _source_id, "context_id" => id}) do
    case AuthContextService.request_token(%{context_id: id}) do
      {:ok, context} -> render(conn, "token.json", token: context)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end

  def toggle_context(conn, %{"context_id" => id, "source_id" => _source_id}) do
    case AuthContextService.toggle_auth_context(%{context_id: id}) do
      {:ok, context} -> render(conn, "show.json", auth_context: context)
      {:error} -> render(conn, HandyApiWeb.ErrorView, :"400")
    end
  end
end
