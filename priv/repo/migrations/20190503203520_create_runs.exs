defmodule CheckpointCharlie.Repo.Migrations.CreateRuns do
  use Ecto.Migration

  def change do
    create table(:runs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :job_spec, :map
      add :checkpoints, :map
      add :stats, :map
      add :meta_data, :map
      add :updates, {:array, :map}
      add :job_id, references(:jobs, on_delete: :nothing, type: :string)

      timestamps()
    end

    create index(:runs, [:job_id])
  end
end
