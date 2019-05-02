defmodule CheckpointCharlie.EctoCron do
    @behaviour Ecto.Type

    def type(), do: :string

    def dump(string) when is_binary(string), do: Ecto.Type.dump(:string, string)
    def dump(_), do: :error
    
    def load(string) when is_binary(string), do: Crontab.CronExpression.Parser.parse(string)
    def load(_), do: :error
    
    def cast(string) when is_binary(string), do: Crontab.CronExpression.Parser.parse(string)
    def cast(_other), do: :error 
end
