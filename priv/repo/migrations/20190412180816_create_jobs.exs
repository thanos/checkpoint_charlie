defmodule CheckpointCharlie.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :is_enabled, :boolean, default: false, null: false
      add :meta_data, :map

      timestamps()
    end

  end
end
