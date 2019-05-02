defmodule CheckpointCharlieWeb.PlayerView do
  use CheckpointCharlieWeb, :view
  alias CheckpointCharlieWeb.PlayerView

  def render("index.json", %{players: players}) do
    %{data: render_many(players, PlayerView, "player.json")}
  end

  def render("show.json", %{player: player}) do
    %{data: render_one(player, PlayerView, "player.json")}
  end

  def render("player.json", %{player: player}) do
    %{id: player.id,
      name: player.name,
      position: player.position,
      number: player.number}
  end
end
