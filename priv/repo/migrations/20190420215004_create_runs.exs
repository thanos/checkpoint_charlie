defmodule CheckpointCharlie.Repo.Migrations.CreateRuns do
  use Ecto.Migration

  def change do
    create table(:runs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :meta_data, :map
      add :job_id, references(:jobs, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:runs, [:job_id])
  end
end
