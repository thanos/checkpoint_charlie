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
    field :job_spec, :map
    embeds_many :checkpoints, CheckpointCharlie.Monitoring.Checkpoint, on_replace: :delete 
    embeds_many :status, CheckpointCharlie.Monitoring.Status, on_replace: :delete 
   
    timestamps()
  end

  @doc false
  def changeset(run, attrs) do
    run
    |> cast(attrs, [:name, :meta_data, :job_id, :job_spec])
    |> validate_required([:name, :meta_data, :job_id, :job_spec])
    |> assoc_constraint(:job)
    |> cast_embed(:checkpoints, with: &cast_checkpoints/2)
  end

  defp cast_checkpoints(checkpoint, params) do
    checkpoint
    |> cast(params, [:name, :last_update, :status, :meta_data])
    |> validate_required([:name, :last_update, :status, :meta_data])
    |> validate_inclusion(:status, ["PENDING", "RUNNING", "DONE", "FAILED"])
  end


  # def changeset(%Checkpoint{} = checkpoint, attrs) do
  #   checkpoint
  #   |> cast(attrs, [:name, :last_update, :status, :meta_data])
  #   |> validate_required([:name, :last_update, :status, :meta_data])
  # end

  # def trace(changeset) do
  #   changeset
  #   |> IO.inspect 
  # end


  # defp cast_field_extraction_regex(field_extraction_regex, params) do
  #   field_extraction_regex
  #   |> trace
  #   |> cast(params, [:run_id_regex, :running_regex, :failed_regex, :done_regex])
  #   |> validate_required([:run_id_regex, :running_regex, :failed_regex, :done_regex])
  #   |> validate_regex([:failed_regex, :running_regex, :run_id_regex, :done_regex])
  # end

  
  # def validate_cron(%Ecto.Changeset{} = changeset, fields) when is_list(fields) do
  #   for field <- fields, do: validate_cron(changeset, field)
  #   changeset
  # end

  # def validate_cron(%Ecto.Changeset{} = changeset, field)  do
  #   case cron_expr = get_field(changeset, field) do
  #     nil -> add_error(changeset, "", "cron_expr missing")
  #     _ ->  case Crontab.CronExpression.Parser.parse(cron_expr) do
  #             {:ok, _} -> changeset
  #             {:error, reason} -> add_error(changeset, cron_expr, reason)
  #           end
  #   end
  # end

  # def validate_regex(%Ecto.Changeset{} = changeset, fields) when is_list(fields) do
  #     for field <- fields, do: validate_regex(changeset, field)
  #     changeset
  # end

  # def validate_regex(%Ecto.Changeset{} = changeset, field)  do
  #   case regex_expr = get_field(changeset, field) do
  #     nil -> add_error(changeset, "", "regex  missing")
  #     _ ->  case Regex.compile(regex_expr) do
  #             {:ok, _} -> changeset
  #             {:error, reason} -> add_error(changeset, regex_expr, reason)
  #           end
  #   end
  # end
  
end
