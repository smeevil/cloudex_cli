defmodule CloudexCli.EnvOptions do

  def merge(%{}=options) do
    [:api_key, :secret, :cloud_name] |> merge(options)
  end

  defp merge([], options) do
    options
  end

  defp merge([key|keys], options) do
    env_value = ("cloudex_" <> Atom.to_string(key)) |> String.upcase |> System.get_env
    new_options = options |> merge_value(key, env_value)
    keys |> merge(new_options)
  end

  defp merge_value(options, key , nil) do
    options
  end

  defp merge_value(options, key , value) do
    new_options = options |> Map.put key, value
    new_options
  end
end