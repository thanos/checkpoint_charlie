defmodule CheckpointCharlie.Repo.Migrations.AddEmbededField do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :checkpoints, {:array, :map}, default: []
    end
  end
end
