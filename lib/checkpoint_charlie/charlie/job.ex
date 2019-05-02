defmodule CheckpointCharlie.Charlie.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckpointCharlie.Monitoring.Run


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "jobs" do
    field :is_enabled, :boolean, default: false
    field :meta_data, :map, default: %{}
    field :name, :string
    field :start_run_by_cron, :string, default: nil
    has_many :run, Run
    embeds_many :checkpoints, CheckPoint, on_replace: :delete  do
      field :meta_dat, :map, default: %{}
      field :name, :string
      field :sla, :float, default: 0.0
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
    |> validate_format(:name, ~r/^\w+\/\w/, message: "must be in the format: group/name", trim: true)    
    |> unique_constraint(:name)
    |> validate_cron(:start_run_by_cron)
    |> cast_embed(:checkpoints, with: &cast_checkpoints/2)
    |> validate_checkpoints_are_unique
  end
  
  defp cast_checkpoints(checkpoint, params) do
    checkpoint
    |> cast(params, [:name, :meta_dat, :sla])
    |> validate_required([:name, :meta_dat, :sla])
    |> cast_embed(:field_extraction_regex, with: &cast_field_extraction_regex/2)

  end

  def validate_checkpoint_name(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case String.starts_with?(url, @our_url) do
        true -> []
        false -> [{field, options[:message] || "Unexpected URL"}]
      end
    end)
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

  # def validate_checkpoints_are_unique(%Ecto.Changeset{} = changeset) do
  #   checkpoints = get_field(changeset, :checkpoints) 
  #   IO.inspect checkpoints
  #   case check_all_unique(Enum.map(checkpoints, fn checkpoint -> checkpoint.name end)) do
  #     {:ok, _}  -> changeset
  #     {:error, dup} -> add_error(changeset, dup, "checkpoint is already defined")
  #   end
  # end

  defp check_all_unique(elements) do
    check_all_unique(elements, MapSet.new)
  end
    
  defp check_all_unique([element | remainder], unique_elements) do
    if MapSet.member?(unique_elements, element) do
      {:error, element}
    else
      check_all_unique(remainder, MapSet.put(unique_elements, element))
    end
  end

  defp check_all_unique([], _) do
    {:ok, []}
  end


  def collect_dups(elements) do
    elements -- Enum.uniq(elements)
  end


  def validate_checkpoints_are_unique(%Ecto.Changeset{} = changeset) do
    validate_checkpoints_are_unique(changeset, collect_dups(Enum.map(get_field(changeset, :checkpoints), fn checkpoint -> checkpoint.name end)))
  end

  def validate_checkpoints_are_unique(%Ecto.Changeset{} = changeset, []), do: changeset


  def validate_checkpoints_are_unique(%Ecto.Changeset{} = changeset, dups) do
      add_errors(changeset, dups, "checkpoint is already defined")
  end

  def add_errors(%Ecto.Changeset{} = changeset, [error | remaining_errors], msg) do
    add_errors(add_error(changeset, error, msg), remaining_errors, msg) 
  end 

  def add_errors(%Ecto.Changeset{} = changeset, [], _) do
    changeset
  end 

  
end
