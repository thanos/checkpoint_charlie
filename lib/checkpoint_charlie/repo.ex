defmodule CheckpointCharlie.Repo do
  use Ecto.Repo,
    otp_app: :checkpoint_charlie,
    adapter: Ecto.Adapters.Postgres
end
