defmodule CheckpointCharlie.Repo.Migrations.RenameRunStartCronField do
  use Ecto.Migration

  def change do
    rename table(:jobs), :run_start_cron, to: :start_run_by_cron
  end
end
