defmodule CheckpointCharlie.Repo.Migrations.AddingRunStartCronField do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :run_start_cron, :string
    end
  end
end
