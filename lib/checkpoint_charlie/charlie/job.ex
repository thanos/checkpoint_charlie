defmodule CheckpointCharlie.Charlie.Job do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "jobs" do
    field :is_enabled, :boolean, default: false
    field :meta_data, :map
    field :name, :string
    embeds_many :checkpoints, CheckPoint,  on_replace: :delete do
      field :meta_dat, :map
      field :name, :string
      field :sla, :float
    end

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :is_enabled, :meta_data])
    |> validate_required([:name, :is_enabled, :meta_data])
    |> cast_embed(:checkpoints, with: &cast_checkpoints/2)
  end
  
  defp cast_checkpoints(checkpoint, params) do
    checkpoint
    |> cast(params, [:name, :meta_dat, :sla])
    |> validate_required([:name, :meta_dat, :sla])
  end

  
  
end
