# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :handy_api,
  namespace: HandyApi

config :phoenix, :json_library, Jason

# Configures the endpoint
config :handy_api, HandyApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j12uJqUP0wYT+DIPlNFHB3EhbxaTsI2T15hnHgOMJvatdpJirfh6bRYCepdO80ej",
  render_errors: [view: HandyApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: HandyApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :handy_api,
  grpc_server_url: "localhost:50051"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
