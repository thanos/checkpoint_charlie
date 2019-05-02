defmodule CheckpointCharlieWeb.JobView do
  use CheckpointCharlieWeb, :view
  alias CheckpointCharlieWeb.JobView

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    %{id: job.id,
      label: job.label,
      is_enabled: job.is_enabled,
      start_run_by_cron: job.start_run_by_cron,
      start_grace_period: job.start_grace_period,
      duration: job.duration,
      duration_grace_period: job.duration_grace_period,
      meta_data: job.meta_data
    }
    |> Map.put(:checkpoints, process("checkpoints.json", job.checkpoints))
  end
  def process("checkpoints.json", checkpoints)  do
    Enum.map(checkpoints, fn cp -> process("checkpoint.json", cp) end)
  end
  
  def process("checkpoint.json", checkpoint) do
    %{
          id: checkpoint.id,
          label: checkpoint.label,
          meta_data: checkpoint.meta_data,
          stats: checkpoint.stats
      } 
  end
end
