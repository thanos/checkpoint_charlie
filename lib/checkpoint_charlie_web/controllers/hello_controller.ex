defmodule CheckpointCharlieWeb.HelloController do
    use CheckpointCharlieWeb, :controller
    def world(conn, %{"name" => name}) do
        render(conn, "world.html", name: name)
    end
end