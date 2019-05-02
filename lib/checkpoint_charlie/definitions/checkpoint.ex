defmodule CheckpointCharlie.Definitions.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias CheckpointCharlie.Definitions.Checkpoint

  alias CheckpointCharlie.Definitions.LabelSlug

  @primary_key {:id, LabelSlug.Type, []}
  @derive {Phoenix.Param, key: :id}
  embedded_schema do
    field :label, :string
    field :meta_data, :map, default: %{}
    field :stats, :map, default: %{}
  end

  @doc false
  def changeset(%Checkpoint{} = checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:label, :meta_data, :stats])
    |> validate_required([:label, :meta_data, :stats])
    |> LabelSlug.maybe_generate_slug  
  end

  def cast_checkpoints(checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:label,  :meta_data, :stats])
    |> validate_required([:label])
    |> LabelSlug.maybe_generate_slug  
  end

  def collect_dups(elements), do: elements -- Enum.uniq(elements)

  def validate_checkpoints_are_unique(%Ecto.Changeset{} = changeset) do

    checkpoints = get_field(changeset, :checkpoints)
    labels = Enum.map(checkpoints, fn checkpoint -> checkpoint.label end)
    dups = collect_dups(labels)
    validate_checkpoints_are_unique(changeset, dups)
  end

  def validate_checkpoints_are_unique(%Ecto.Changeset{} = changeset, []), do: changeset

  def validate_checkpoints_are_unique(%Ecto.Changeset{} = changeset, dups) do
      add_errors(changeset, dups, "checkpoint is already defined")
  end


  def add_errors(%Ecto.Changeset{} = changeset, [error | remaining_errors], msg) do
    add_errors(add_error(changeset, error, msg), remaining_errors, msg) 
  end 
  def add_errors(%Ecto.Changeset{} = changeset, [], _), do: changeset


end
