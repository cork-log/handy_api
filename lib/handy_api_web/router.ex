defmodule HandyApiWeb.Router do
  use HandyApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HandyApiWeb do
    pipe_through :api
    get "/source", SourceController, :index
  end
end
