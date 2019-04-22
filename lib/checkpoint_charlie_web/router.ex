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
  end

  # Other scopes may use custom stacks.
  scope "/api", CheckpointCharlieWeb do
    pipe_through :api
    resources "/jobs", JobController, except: [:new, :edit]
    resources "/runs", RunController, except: [:new, :edit]

    get "/runs/invoke/:job_id", RunController, :invoke
    get "/runs/:id/checkpoint/:checkpoint_id/start", JobController, :checkpoint_start
    get "/runs/:id/checkpoint/:checkpoint_id/failed", JobController, :checkpoint_failed
    get "/runs/:id/checkpoint/:checkpoint_id/done", JobController, :checkpoint_done
    get "/runs/:id/checkpoint/:checkpoint_id", JobController, :checkpoint_status
  end
end
