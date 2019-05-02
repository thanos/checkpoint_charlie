defmodule CheckpointCharlie.PlayPen.Slug do
    use EctoAutoslugField.Slug, from: :name, to: :id
end