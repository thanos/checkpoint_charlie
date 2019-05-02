defmodule CheckpointCharlie.Definitions.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckpointCharlie.Definitions.Checkpoint

  alias CheckpointCharlie.Definitions.LabelSlug
  @primary_key {:id, LabelSlug.Type, []}
  @derive {Phoenix.Param, key: :id}
  schema "jobs" do
    field :duration, :integer
    field :duration_grace_period, :integer
    field :is_enabled, :boolean, default: false
    field :label, :string
    field :meta_data, :map
    field :start_grace_period, :integer
    field :start_run_by_cron, :string
    embeds_many :checkpoints, Checkpoint, on_replace: :delete 

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:label, :is_enabled, :start_run_by_cron, :start_grace_period, :duration, :duration_grace_period, :meta_data])
    |> validate_required([:label, :is_enabled, :start_run_by_cron, :start_grace_period, :duration, :duration_grace_period])
    |> validate_format(:label, ~r/^\w+\/\w/, message: "label must be in the format: group/name", trim: true)    
    |> validate_duration
    |> unique_constraint(:label, name: :jobs_pkey2)
    |> validate_cron(:start_run_by_cron)
    |> cast_embed(:checkpoints, with: &Checkpoint.cast_checkpoints/2)
    |> Checkpoint.validate_checkpoints_are_unique
    |> LabelSlug.maybe_generate_slug  
    |> LabelSlug.unique_constraint
  end




  defp validate_duration(%Ecto.Changeset{} = changeset) do
  changeset
    |> validate_number(:duration, greater_than_or_equal_to: 60, message: "duration (secs) has to be greater than 60")
    |> validate_number(:duration_grace_period, less_than_or_equal_to: 100, message:  "duration_grace_period should be a percentage of duration")
  end


  defp validate_cron(%Ecto.Changeset{} = changeset, field)  do
    case cron_expr = get_field(changeset, field) do
      nil -> changeset
      _ ->  case Crontab.CronExpression.Parser.parse(cron_expr) do
              {:ok, _} -> changeset
              {:error, reason} -> add_error(changeset, cron_expr, reason)
            end
    end
  end


end
