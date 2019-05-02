defmodule CheckpointCharlie.PlayPen.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckpointCharlie.PlayPen.Slug

  @primary_key {:id, Slug.Type, []}
  @derive {Phoenix.Param, key: :id}
  schema "players" do
    field :name, :string
    field :number, :integer
    field :position, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :position, :number])
    |> validate_required([:name, :position, :number])
    |> validate_format(:name, ~r/^\w+\/\w/, message: "must be in the format: group/name", trim: true)    
    |> Slug.maybe_generate_slug
    |> Slug.unique_constraint
  end
end
