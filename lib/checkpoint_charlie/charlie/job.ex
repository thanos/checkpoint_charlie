defmodule CheckpointCharlie.Charlie.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckpointCharlie.Monitoring.Run


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "jobs" do
    field :is_enabled, :boolean, default: false
    field :meta_data, :map
    field :name, :string
    field :start_run_by_cron, :string, default: nil
    has_many :run, Run
    embeds_many :checkpoints, CheckPoint do
      field :meta_dat, :map
      field :name, :string
      field :sla, :float
      field :status, :string
      embeds_one :field_extraction_regex, FieldExtractionRegex do
        field :run_id_regex, :string
        field :running_regex,  :string
        field :failed_regex,  :string
        field :done_regex,  :string
      end
    end

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :is_enabled, :start_run_by_cron,  :meta_data])
    |> validate_required([:name, :is_enabled, :start_run_by_cron, :meta_data])
    |> validate_cron(:start_run_by_cron)
    |> cast_embed(:checkpoints, with: &cast_checkpoints/2)

  end
  
  defp cast_checkpoints(checkpoint, params) do
    checkpoint
    |> cast(params, [:name, :meta_dat, :sla, :status])
    |> validate_required([:name, :meta_dat, :sla, :status])
    |> cast_embed(:field_extraction_regex, with: &cast_field_extraction_regex/2)
  end

  def trace(changeset) do
    changeset
    |> IO.inspect 
  end


  defp cast_field_extraction_regex(field_extraction_regex, params) do
    field_extraction_regex
    |> trace
    |> cast(params, [:run_id_regex, :running_regex, :failed_regex, :done_regex])
    |> validate_required([:run_id_regex, :running_regex, :failed_regex, :done_regex])
    |> validate_regex([:failed_regex, :running_regex, :run_id_regex, :done_regex])
  end

  
  def validate_cron(%Ecto.Changeset{} = changeset, fields) when is_list(fields) do
    for field <- fields, do: validate_cron(changeset, field)
    changeset
  end

  def validate_cron(%Ecto.Changeset{} = changeset, field)  do
    case cron_expr = get_field(changeset, field) do
      nil -> add_error(changeset, "", "cron_expr missing")
      _ ->  case Crontab.CronExpression.Parser.parse(cron_expr) do
              {:ok, _} -> changeset
              {:error, reason} -> add_error(changeset, cron_expr, reason)
            end
    end
  end

  def validate_regex(%Ecto.Changeset{} = changeset, fields) when is_list(fields) do
      for field <- fields, do: validate_regex(changeset, field)
      changeset
  end

  def validate_regex(%Ecto.Changeset{} = changeset, field)  do
    case regex_expr = get_field(changeset, field) do
      nil -> add_error(changeset, "", "regex  missing")
      _ ->  case Regex.compile(regex_expr) do
              {:ok, _} -> changeset
              {:error, reason} -> add_error(changeset, regex_expr, reason)
            end
    end
  end
  
end
