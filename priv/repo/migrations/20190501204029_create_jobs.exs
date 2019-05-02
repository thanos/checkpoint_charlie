defmodule CheckpointCharlie.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :label, :string
      add :is_enabled, :boolean, default: false, null: false
      add :start_run_by_cron, :string
      add :start_grace_period, :integer
      add :duration, :integer
      add :duration_grace_period, :integer
      add :meta_data, :map
      add :checkpoints, {:array, :map}

      timestamps()
    end

  end
end
