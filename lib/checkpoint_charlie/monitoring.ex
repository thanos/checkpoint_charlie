defmodule CheckpointCharlie.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

  import Ecto.Query, warn: false
  alias CheckpointCharlie.Repo

  alias CheckpointCharlie.Monitoring.Run
  alias CheckpointCharlie.Charlie.Job

  @doc """
  Returns the list of runs.

  ## Examples

      iex> list_runs()
      [%Run{}, ...]

  """
  def list_runs do
    Repo.all(Run)
  end

  @doc """
  Gets a single run.

  Raises `Ecto.NoResultsError` if the Run does not exist.

  ## Examples

      iex> get_run!(123)
      %Run{}

      iex> get_run!(456)
      ** (Ecto.NoResultsError)

  """
  def get_run!(id), do: Repo.get!(Run, id)


  def get_run_by(params) do 
    Repo.get_by(Run, params)
  end


  @doc """
  Creates a run.

  ## Examples

      iex> create_run(%{field: value})
      {:ok, %Run{}}

      iex> create_run(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_run(attrs \\ %{}) do
    %Run{}
    |> Run.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a run.

  ## Examples

      iex> update_run(run, %{field: new_value})
      {:ok, %Run{}}

      iex> update_run(run, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_run(%Run{} = run, attrs) do
    run
    |> Run.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Run.

  ## Examples

      iex> delete_run(run)
      {:ok, %Run{}}

      iex> delete_run(run)
      {:error, %Ecto.Changeset{}}

  """
  def delete_run(%Run{} = run) do
    Repo.delete(run)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking run changes.

  ## Examples

      iex> change_run(run)
      %Ecto.Changeset{source: %Run{}}

  """
  def change_run(%Run{} = run) do
    Run.changeset(run, %{})
  end


  def start_run(%Job{} = job = job, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{
      meta_data: job.meta_data,
      name: job.name,
      job_id: job.id
    })

    %Run{}
      |> Run.changeset(attrs)
      |> Repo.insert()
  end

end