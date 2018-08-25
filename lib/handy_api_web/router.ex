defmodule HandyApiWeb.Router do
  use HandyApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HandyApiWeb do
    pipe_through :api
    get "/source/:id", SourceController, :show
    get "/sources", SourceController, :get_sources
    post "/source", SourceController, :create

    post "/source/:source_id/entry", EntryController, :insert
    get "/source/:source_id/entry", EntryController, :get_entries

    post "/source/:source_id/auth", AuthContextController, :insert
    get "/source/:source_id/auth/:context_id/token", AuthContextController, :request_token
    get "/source/:source_id/auth", AuthContextController, :get_contexts
    patch "/source/:source_id/auth/:context_id/toggle", AuthContextController, :toggle_context

    post "/source/:source_id/job", JobDescriptorController, :insert
    get "/source/:source_id/job", JobDescriptorController, :get_descriptors
    put "/source/:source_id/job/:job_descriptor_id", JobDescriptorController, :edit

  end
end
