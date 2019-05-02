defmodule CheckpointCharlie.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :position, :string
      add :number, :integer

      timestamps()
    end

  end
end
