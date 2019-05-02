defmodule CheckpointCharlie.Charlie do
  @moduledoc """
  The Charlie context.
  """

  import Ecto.Query, warn: false
  alias CheckpointCharlie.Repo

  alias CheckpointCharlie.Charlie.Job
  alias CheckpointCharlie.Monitoring
  

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """
  def list_jobs do
    Repo.all(Job)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id), do: Repo.get!(Job, id)


  def get_job_by(params) do 
    Repo.get_by(Job, params)
  end

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{source: %Job{}}

  """
  def change_job(%Job{} = job) do
    Job.changeset(job, %{})
  end

  def update_checkpoint(%Job{} = job, checkpoint_id, status) do
    index = Enum.find_index(job.checkpoints, fn cp -> cp.id == checkpoint_id end)
    checkpoint = Enum.at(job.checkpoints,index)

    # checkpoint = Enum.find(job.checkpoints, fn cp -> cp.id == checkpoint_id end) 
    changeset = Ecto.Changeset.change(job)
    checkpoint_changeset = Ecto.Changeset.change(checkpoint, status: status) 
    checkpoints = List.update_at(job.checkpoints, index, fn x -> checkpoint_changeset end)
    job_chageset = Ecto.Changeset.put_embed(changeset, :checkpoints, checkpoints)
    Repo.update!(job_chageset)
  end

  # def update_checkpoint(%Job{} = job, checkpoint) do

  #   index = Enum.find_index(job.checkpoints, fn cp -> cp.id == checkpoint.id end) 
  #   # checkpoint = Map.put(checkpoint, :id, nil)
  #   # checkpoint = Enum.at(job.checkpoints,index)
  #   # checkpoints = List.update_at(job.checkpoints, index, fn x -> Map.put(checkpoint, :status, checkpoint.status) end)
  #   checkpoints = List.update_at(job.checkpoints, index, fn x -> checkpoint end)
   
  #   IO.inspect update_checkpoints(job, checkpoints)
  # end



  def start_job(%Job{} = job, attrs \\ %{}) do
      attrs = Enum.into(attrs, %{
        job_spec: CheckpointCharlieWeb.JobView.render("job.json", %{job: job}),
        name: job.name,
        job_id: job.id,
        meta_data: %{},
        checkpoints: Enum.map(job.checkpoints, fn x -> %{
                          checkpoint_id: x.id,
                          name: x.name,
                          sla: x.sla,
                          status: "PENDING",
                          meta_data: %{},
                          last_update: NaiveDateTime.utc_now()
                      } end),
      })
      Monitoring.create_run(attrs)
  end

end
