defmodule CheckpointCharlie.Monitoring.Run do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "runs" do
    field :checkpoints, :map
    field :job_spec, :map
    field :meta_data, :map
    field :stats, :map
    field :updates, {:array, :map}
    field :job_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(run, attrs) do
    run
    |> cast(attrs, [:job_spec, :checkpoints, :stats, :meta_data, :updates])
    |> validate_required([:job_spec, :checkpoints, :stats, :meta_data, :updates])
  end
end
