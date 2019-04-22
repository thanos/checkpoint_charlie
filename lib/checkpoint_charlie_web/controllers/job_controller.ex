defmodule CheckpointCharlieWeb.JobController do
  use CheckpointCharlieWeb, :controller

  alias CheckpointCharlie.Charlie
  alias CheckpointCharlie.Charlie.Job
  alias CheckpointCharlieWeb.CheckpointView

  action_fallback CheckpointCharlieWeb.FallbackController

  def index(conn, _params) do
    jobs = Charlie.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end

  def create(conn, %{"job" => job_params}) do
    with {:ok, %Job{} = job} <- Charlie.create_job(job_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Charlie.get_job!(id)
    render(conn, "show.json", job: job)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Charlie.get_job!(id)

    with {:ok, %Job{} = job} <- Charlie.update_job(job, job_params) do
      render(conn, "show.json", job: job)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Charlie.get_job!(id)

    with {:ok, %Job{}} <- Charlie.delete_job(job) do
      send_resp(conn, :no_content, "")
    end
  end


  


  # def checkpoint_status(conn, %{"id" => id, "checkpoint_id" => checkpoint_id, "params" => params}) do
  #   job = Charlie.get_job!(id)
  #   checkpoint = Enum.find(job.checkpoints, fn cp -> cp.id == "checkpoint_id" end) 
  #   render(conn, "checkpoint.json", checkpoint: checkpoint)
  # end

  def checkpoint_status(conn, %{"id" => id, "checkpoint_id" => checkpoint_id}) do
    job = Charlie.get_job!(id)
    job = Charlie.update_checkpoint(job, checkpoint_id, "RUNNING")
    render(conn, "show.json", job: job)
    # json(conn, %{
    #   id: checkpoint.id,
    #    sla: checkpoint.sla,
    #    name: checkpoint.name,
    #    meta_dat: checkpoint.meta_dat
    #      } )
    # render(conn,"checkpoint.json", checkpoint: checkpoint)
  end


  def checkpoint_failed(conn, %{"id" => id, "checkpoint_id" => checkpoint_id}) do
    job = Charlie.get_job!(id)
    job = Charlie.update_checkpoint(job, checkpoint_id, "FAILED")
    render(conn, "show.json", job: job)
  end


end
