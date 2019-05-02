defmodule CheckpointCharlie.Repo.Migrations.TestNames do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :running?, :boolean, default: false, null: false
    end
  end
end

