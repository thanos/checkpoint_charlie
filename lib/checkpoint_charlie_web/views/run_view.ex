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
    %{id: run.id,
      job_spec: run.job_spec,
      checkpoints: run.checkpoints,
      stats: run.stats,
      meta_data: run.meta_data,
      updates: run.updates}
  end
end
