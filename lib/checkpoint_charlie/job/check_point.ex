defmodule CheckpointCharlie.Job.CheckPoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias CheckpointCharlie.Job.CheckPoint

  embedded_schema do
    field :meta_dat, :map
    field :name, :string
    field :sla, :float
  end

  @doc false
  def changeset(%CheckPoint{} = check_point, attrs) do
    check_point
    |> cast(attrs, [:name, :meta_dat, :sla])
    |> validate_required([:name, :meta_dat, :sla])
  end
end
