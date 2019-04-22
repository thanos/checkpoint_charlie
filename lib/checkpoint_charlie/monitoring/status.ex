defmodule CheckpointCharlie.Monitoring.Status do
  use Ecto.Schema
  import Ecto.Changeset
  alias CheckpointCharlie.Monitoring.Status

  embedded_schema do
    field :meta_data, :map
    field :status, :string
    field :timestamp, :utc_datetime
  end

  @doc false
  def changeset(%Status{} = status, attrs) do
    status
    |> cast(attrs, [:status, :timestamp, :meta_data])
    |> validate_required([:status, :timestamp, :meta_data])
  end
end
