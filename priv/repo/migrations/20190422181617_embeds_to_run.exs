defmodule CheckpointCharlie.Repo.Migrations.EmbedsToRun do
  use Ecto.Migration

  def change do
    alter table(:runs) do
      add :job_spec, :map
      add :checkpoints, {:array, :map}, default: []
      add :status, {:array, :map}, default: []
    end
  end
end
