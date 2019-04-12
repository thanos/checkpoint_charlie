use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :checkpoint_charlie, CheckpointCharlieWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :checkpoint_charlie, CheckpointCharlie.Repo,
  username: "devuser",
  password: "devuser",
  database: "checkpoint_charlie_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
