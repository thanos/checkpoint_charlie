defmodule CheckpointCharlieWeb.JobController do
  use CheckpointCharlieWeb, :controller
  use PhoenixSwagger
  
  alias CheckpointCharlie.Definitions
  alias CheckpointCharlie.Definitions.Job



  action_fallback CheckpointCharlieWeb.FallbackController

  def swagger_definitions do
    %{
      Job: swagger_schema do
        title "Job"
        description "The definintion of a Job"
        properties do
          id :string, "The ID of the job definition", pattern: "^\w\/w"
          label :string, "The ID of the job definition"
          start_run_by_cron :string, "The job definition recorded", required: true
          duration :integer, "How far travelled", required: true
          duration_grace_period :integer, "How far travelled", required: true
          inserted_at :string, "When was the job definition initially inserted", format: "ISO-8601"
          updated_at :string, "When was the job definition last updated", format: "ISO-8601"
          is_enabled :boolean, "lets you diable this job definition"
          meta_data :object, "Job owner defined data", additionalProperties: true
          checkpoints :array, "An array of checkpoint definitions", items: (Schema.new do
            properties do
              id :string, "The ID of the checkpoint definition"
              label :string, "The label of the checkpoint definition"
              meta_data :object, "User defined data"
              stats :object, "User defined data", readOnly: true
            end
          end)
        end
        example %{
          checkpoints: [
            %{
              id: "control-file-received",
              label: "Control File Received",
              meta_data: %{},
              stats: %{}
            },
            %{
              id: "spark-jobs-filtering",
              label: "Spark Jobs Filtering",
              meta_data: %{},
              stats: %{}
            },
            %{
                id: "collating-and-decorating-filtered-files",
                label: "Collating and Decorating Filtered Files",
                meta_data: %{},
                stats: %{}
            },
            %{
                  id: "uploading-files",
                  label: "Uploading Files",
                  meta_data: %{},
                  stats: %{}
            }
            ],
            duration: 120,
            duration_grace_period: 42,
            id: "wba0-raftd127",
            is_enabled: false,
            label: "WBA0/RAFTD127",
            meta_data: nil,
            start_grace_period: 42,
            start_run_by_cron: "*/15 * * * *"
          }
      end,
      # CheckpointDefinitions: swagger_schema do
      #   title "Checkpoint"
      #   description "A collection of Checkpoint Definitions"
      #   type :array
      #   items Schema.ref(:Job)
      # end,
      Jobs: swagger_schema do
        title "Jobs"
        description "A collection of Jobs"
        type :array
        items Schema.ref(:Job)
      end
    }
  end


  swagger_path :index do
    summary "Retrives a list of Job Definitions"
    description "List jobs"
    response 200, "Success",  Schema.ref(:Jobs)
  end

  def index(conn, _params) do
    jobs = Definitions.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end

  swagger_path :create do
    summary "Creates a Job Definition"
    description "Create a Job Deinfinition"
    response 201, "Success",  Schema.ref(:Job)
  end

  def create(conn, %{"job" => job_params}) do
    with {:ok, %Job{} = job} <- Definitions.create_job(strip_stats(job_params)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.job_path(conn, :show, job))
      |> render("show.json", job: job)
    end
  end


  swagger_path :show do
    summary "Retrieve a Job Definition"
    description "get a Job Deinfinition by id"
    parameters do
     id :path, :string, "The id [slug(label)] of the Job definition", required: true
    end
    response 200, "Ok", Schema.ref(:Job)
    response 404, "Not found"
  end

  def show(conn, %{"id" => id}) do
    job = Definitions.get_job!(id)
    render(conn, "show.json", job: job)
  end


  swagger_path :update do
    summary "Update a Job Definition"
    description "Update a Job Deinfinition"
    parameters do
      id :path, :string, "The id [slug(label)] of the Job definition", required: true
     end
     response 200, "Ok", Schema.ref(:Job)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Definitions.get_job!(id)

    with {:ok, %Job{} = job} <- Definitions.update_job(job, strip_stats(job_params)) do
      render(conn, "show.json", job: job)
    end
  end


  swagger_path :delete do
    description "Deletes a Job Deinfinition by id"
    summary "Deletes a Job Definition"
    parameters do
     id :path, :string, "The id [slug(label)] of the Job definition", required: true
    end
    response 200, "Ok", Schema.ref(:Job)
    response 404, "Not found"
  end

  def delete(conn, %{"id" => id}) do
    job = Definitions.get_job!(id)

    with {:ok, %Job{}} <- Definitions.delete_job(job) do
      send_resp(conn, :no_content, "")
    end
  end

  def strip_stats(params) do
    case checkpoints = Map.get(params, "checkpoints") do
      nil -> params
      _ -> Map.put(params, "checkpoints", Enum.map(checkpoints, fn x -> Map.drop(x, ["stats"]) end))
    end
  end
    
end
