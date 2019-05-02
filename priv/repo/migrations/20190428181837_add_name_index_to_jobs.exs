defmodule CheckpointCharlie.Repo.Migrations.AddNameIndexToJobs do
  use Ecto.Migration

  def change do
    create unique_index(:jobs, [:name])
  end
end
