defmodule HandyApiWeb.AuthContextView do
  use HandyApiWeb, :view
  alias HandyApiWeb.AuthContextView

  def render("token.json", %{token: token}) do
    %{token: token}
  end

  def render("index.json", %{auth_contexts: auth_contexts}) do
    render_many(auth_contexts, AuthContextView, "auth_context.json")
  end

  def render("show.json", %{auth_context: auth_context}) do
    render_one(auth_context, AuthContextView, "auth_context.json")
  end

  def render("auth_context.json", %{auth_context: context}) do
    %{id: context.id, name: context.name, enabled: context.enabled, source_id: context.source_id}
  end
end
