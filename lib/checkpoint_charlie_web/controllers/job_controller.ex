defmodule CheckpointCharlieWeb.JobController do
  use CheckpointCharlieWeb, :controller

  alias CheckpointCharlie.Charlie
  alias CheckpointCharlie.Charlie.Job

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
end
