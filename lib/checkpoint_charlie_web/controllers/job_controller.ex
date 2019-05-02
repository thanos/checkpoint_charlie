defmodule CheckpointCharlieWeb.JobController do
  use CheckpointCharlieWeb, :controller

  alias CheckpointCharlie.Definitions
  alias CheckpointCharlie.Definitions.Job

  action_fallback CheckpointCharlieWeb.FallbackController

  def index(conn, _params) do
    jobs = Definitions.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end

  def create(conn, %{"job" => job_params}) do
    with {:ok, %Job{} = job} <- Definitions.create_job(strip_stats(job_params)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Definitions.get_job!(id)
    render(conn, "show.json", job: job)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Definitions.get_job!(id)

    with {:ok, %Job{} = job} <- Definitions.update_job(job, strip_stats(job_params)) do
      render(conn, "show.json", job: job)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Definitions.get_job!(id)

    with {:ok, %Job{}} <- Definitions.delete_job(job) do
      send_resp(conn, :no_content, "")
    end
  end

  def strip_stats(params), do: Map.put(params, "checkpoints", Enum.map(Map.get(params, "checkpoints"), fn x -> Map.drop(x, ["stats"]) end))
    
end
