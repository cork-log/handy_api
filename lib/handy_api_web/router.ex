defmodule HandyApiWeb.Router do
  use HandyApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HandyApiWeb do
    pipe_through :api
    get "/source/:id", SourceController, :show
    post "/source", SourceController, :create
    post "/source/:source_id/entry", EntryController, :insert
    get "/source/:source_id/entry", EntryController, :get_entries
  end
end
