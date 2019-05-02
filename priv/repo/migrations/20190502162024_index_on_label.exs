defmodule CheckpointCharlie.Repo.Migrations.IndexOnLabel do
  use Ecto.Migration

  def change do
    create unique_index(:jobs, [:label])
  end
end
