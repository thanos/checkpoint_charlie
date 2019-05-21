defmodule CheckpointCharlieWeb.Router do
  use CheckpointCharlieWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CheckpointCharlieWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/job/:id", PageController, :job
    get "/hello/:name", HelloController, :world
  end

  # Other scopes may use custom stacks.
  scope "/api", CheckpointCharlieWeb do
    pipe_through :api
    resources "/jobs", JobController, except: [:new, :edit]
    resources "/runs", RunController, except: [:new, :edit]
    resources "/player", PlayerController, except: [:new, :edit]
    get "/runs/invoke/:job_id", RunController, :invoke
    get "/runs/:id/checkpoint/:checkpoint_id/start", JobController, :checkpoint_start
    get "/runs/:id/checkpoint/:checkpoint_id/failed", JobController, :checkpoint_failed
    get "/runs/:id/checkpoint/:checkpoint_id/done", JobController, :checkpoint_done
    get "/runs/:id/checkpoint/:checkpoint_id", JobController, :checkpoint_status
  end


  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :checkpoint_charlie, swagger_file: "swagger.json"
  end


  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Checkpoint Charlie"
      }
    }
  end
end
