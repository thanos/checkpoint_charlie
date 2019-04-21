defmodule CheckpointCharlie.Monitoring.Run do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckpointCharlie.Charlie.Job

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "runs" do
    field :meta_data, :map
    field :name, :string
    belongs_to :job, Job

    timestamps()
  end

  @doc false
  def changeset(run, attrs) do
    run
    |> cast(attrs, [:name, :meta_data, :job_id])
    |> validate_required([:name, :meta_data])
    |> assoc_constraint(:job)
  end
end
