use Mix.Config
import_config "dev.exs"

config :handy_api,
  grpc_server_url: "gateway:50051"

