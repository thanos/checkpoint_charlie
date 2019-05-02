defmodule CheckpointCharlieWeb.RunView do
  use CheckpointCharlieWeb, :view
  alias CheckpointCharlieWeb.RunView

  def render("index.json", %{runs: runs}) do
    %{data: render_many(runs, RunView, "run.json")}
  end

  def render("show.json", %{run: run}) do
    %{data: render_one(run, RunView, "run.json")}
  end

  def render("run.json", %{run: run}) do
    %{
      id: run.id,
      job_id: run.job_id,
      name: run.name,
      meta_data: run.meta_data,
      inserted_at: run.inserted_at,
      updated_at: run.updated_at
      # job_spec: run.job_spec,
    }
    |> Map.put(:checkpoints, process("checkpoints.json", run.checkpoints))
  end

  def process("checkpoints.json", checkpoints)  do
    Enum.map(checkpoints, fn cp -> process("checkpoint.json", cp) end)
  end
  
  def process("checkpoint.json", checkpoint) do
    %{
          id: checkpoint.id,
          name: checkpoint.name,
          meta_data: checkpoint.meta_data,
          status: checkpoint.status,
      } 
  end
end
