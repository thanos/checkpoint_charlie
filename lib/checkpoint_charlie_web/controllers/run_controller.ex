defmodule CheckpointCharlieWeb.RunController do
  use CheckpointCharlieWeb, :controller

  alias CheckpointCharlie.Monitoring
  alias CheckpointCharlie.Monitoring.Run
  alias CheckpointCharlie.Charlie

  action_fallback CheckpointCharlieWeb.FallbackController

  def index(conn, _params) do
    runs = Monitoring.list_runs()
    render(conn, "index.json", runs: runs)
  end

  def create(conn, %{"run" => run_params}) do
    with {:ok, %Run{} = run} <- Monitoring.create_run(run_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.run_path(conn, :show, run))
      |> render("show.json", run: run)
    end
  end

  def show(conn, %{"id" => id}) do
    run = Monitoring.get_run!(id)
    render(conn, "show.json", run: run)
  end

  def update(conn, %{"id" => id, "run" => run_params}) do
    run = Monitoring.get_run!(id)

    with {:ok, %Run{} = run} <- Monitoring.update_run(run, run_params) do
      render(conn, "show.json", run: run)
    end
  end

  def delete(conn, %{"id" => id}) do
    run = Monitoring.get_run!(id)

    with {:ok, %Run{}} <- Monitoring.delete_run(run) do
      send_resp(conn, :no_content, "")
    end
  end


  def invoke(conn, %{"job_id" => job_id}) do
    job = Charlie.get_job!(job_id)
    with {:ok, %Run{} = run} <- Monitoring.start_run(job) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.run_path(conn, :show, run))
      |> render("show.json", run: run)
    end
  end


end
