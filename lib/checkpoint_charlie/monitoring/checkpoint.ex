defmodule CheckpointCharlie.Monitoring.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias CheckpointCharlie.Monitoring.Checkpoint

  embedded_schema do
    field :last_update, :utc_datetime
    field :meta_data, :map
    field :name, :string
    field :status, :string
  end

  @doc false
  def changeset(%Checkpoint{} = checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:name, :last_update, :status, :meta_data])
    |> validate_required([:name, :last_update, :status, :meta_data])
  end
end
