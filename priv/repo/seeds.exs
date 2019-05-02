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
alias CheckpointCharlie.Definitions



# p = %{name: "WBA0/raft2", number: 2, position: "forward"}
# {:ok, %PlayPen.Player{} = player} = PlayPen.create_player(p)
job_spec =  %{
    duration: 120, 
    duration_grace_period: 42, 
    label: "WBA0/RAFTD11", 
    start_grace_period: 42, 
    start_run_by_cron: "*/15 * * * *",
    checkpoints: [
      %{label: "Control File Received"},
      %{label: "Spark Jobs Filtering"},
      %{label: "Collating and Decorating Filtered Files"},
      %{label: "Uploading Files"}
      ]
}

#:ok = CheckpointCharlie.Charlie.Job.check_checkpoints(job_spec.checkpoints)
{:ok, %Definitions.Job{} = job} = Definitions.create_job(job_spec)
# job = Charlie.get_job!("ff476f99-e472-4e04-9858-9967887f331c")
# Charlie.start_job(job)
# |> IO.inspect
# # job
# # |> IO.inspect
# # checkpoints = job.checkpoints
# # Enum.map(job.checkpoints, fn x -> %{
# #     checkpoint_id: x.id,
# #     name: x.name,
# #     sla: x.sla,
# #     status: "PENDING"
# # } end)
# # |> IO.inspect