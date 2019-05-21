# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :checkpoint_charlie,
  ecto_repos: [CheckpointCharlie.Repo]

# Configures the endpoint
config :checkpoint_charlie, CheckpointCharlieWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3sH0o3GJZPXUWPsX+LMknIn+JLqnNzdkPWBLwMDRhD13sDfhVQRGgGTf9UDESs7X",
  render_errors: [view: CheckpointCharlieWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CheckpointCharlie.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  # config :phoenix, :template_engines,
  #   dtl: PhoenixDtl.Engine

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.


config :torch,
  otp_app: :checkpoint_charlie,
  template_format: "eex" || "slim"


  config :checkpoint_charlie, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: CheckpointCharlieWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: CheckpointCharlieWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }


import_config "#{Mix.env()}.exs"
