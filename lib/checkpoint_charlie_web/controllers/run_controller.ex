defmodule CheckpointCharlieWeb.RunController do
  use CheckpointCharlieWeb, :controller

  alias CheckpointCharlie.Monitoring
  alias CheckpointCharlie.Monitoring.Run

  action_fallback CheckpointCharlieWeb.FallbackController
  use PhoenixSwagger

  # field :checkpoints, :map
  # field :job_spec, :map
  # field :meta_data, :map
  # field :stats, :map
  # field :updates, {:array, :map}
  # field :job_id, :binary_id
  def swagger_definitions do
    %{
      Run: swagger_schema do
        title "Run"
        description "The definintion of a Run"
        properties do
          id :string, "uuid run id"
          job_id :string, "forgign key to job defininition", required: true
          checkpoints :object
          job_spec  :object
          stats :object
          updates  :array, "An array of update objects", items: (Schema.new do
            properties do
              id :string, "The ID of the checkpoint definition"
              label :string, "The label of the checkpoint definition"
              meta_data :object, "User defined data"
              stats :object, "User defined data"
            end
          end)
          
          inserted_at :string, "When was the activity initially inserted", format: "ISO-8601"
          updated_at :string, "When was the activity last updated", format: "ISO-8601"

        end
        example %{
          completed_at: "2017-03-21T14:00:00Z",
          activity: "climbing",
          distance: 150
        }
      end
    }
  end

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
end
