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
      name: job.name,
      is_enabled: job.is_enabled,
      meta_data: job.meta_data}
  end
end
