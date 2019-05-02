defmodule CheckpointCharlie.Definitions.LabelSlug do
    use EctoAutoslugField.Slug, from: :label, to: :id
end