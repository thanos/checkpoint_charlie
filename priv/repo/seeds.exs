# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CheckpointCharlie.Repo.insert!(%CheckpointCharlie.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

  
alias CheckpointCharlie.Charlie
job_spec =  %{
        is_enabled: true, 
        meta_data: %{}, 
        start_run_by_cron: "* * * *", 
        name: "risk run", 
        checkpoints: [
          %{name: "stage 1", meta_dat: %{}, sla: 0.3},
          %{name: "stage 2", meta_dat: %{}, sla: 0.7},
          ],
        field_extraction_regex: %{
          done_regex: "\d",
          failed_regex: "\d",
          run_id_regex: "\d",
          runnning_regex: "\d"
        }
      }


# {:ok, %Charlie.Job{} = job} = Charlie.create_job(job_spec)
job = Charlie.get_job!("ff476f99-e472-4e04-9858-9967887f331c")
Charlie.start_job(job)
|> IO.inspect
# job
# |> IO.inspect
# checkpoints = job.checkpoints
# Enum.map(job.checkpoints, fn x -> %{
#     checkpoint_id: x.id,
#     name: x.name,
#     sla: x.sla,
#     status: "PENDING"
# } end)
# |> IO.inspect