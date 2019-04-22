defmodule CheckpointCharlieWeb.CheckpointView do
    use CheckpointCharlieWeb, :view
    alias CheckpointCharlieWeb.CheckpointView

    def render("checkpoints.json", %{checkpoints: checkpoints}) when is_list(checkpoints) do
        render_many(checkpoints, CheckpointView, "checkpoint.json")
    end
      
    def render("checkpoint.json", %{checkpoint: checkpoint}) do
      %{
     id: checkpoint.id,
      sla: checkpoint.sla,
      name: checkpoint.name,
      meta_dat: checkpoint.meta_dat,
        } 
    end
  end
  