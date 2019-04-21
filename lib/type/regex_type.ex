defmodule CheckpointCharlie.Type.Regex do
    @behaviour Ecto.Type
  
    def type, do: :map
  
    def cast(string) when is_binary(string) do
      Regex.compile(string)
    end
  
    def cast(%Regex{} = regex) do
      {:ok, regex}
    end
  
    def cast(_), do: :error
  
    def load(string) when is_binary(string) do
      Regex.compile(string)
    end
  
  
    def dump(%Regex{} = regex), do: {:ok, Regex.source(regex)}
    def dump(_), do: :error
  end