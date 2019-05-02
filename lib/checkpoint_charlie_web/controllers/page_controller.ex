defmodule CheckpointCharlieWeb.PageController do
  use CheckpointCharlieWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def job(conn, %{"id" => id}) do
    render(conn, "job.html", id: id)
end
end
