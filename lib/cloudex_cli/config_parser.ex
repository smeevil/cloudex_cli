defmodule CloudexCli.ConfigParser do
  alias CloudexCli.EnvOptions

  def parse(args) do
    {options, list} = args |> parse_args
    case options |> parse_options do
      {:ok, config} -> {:ok, %{config: config, list: list}}
      {:error, message} -> {:error, message}
    end

  end

  defp parse_options(cli_options) do
    cli_options
      |> process_config_file
      |> merge_env_options
      |> merge_cli_options(cli_options)
      |> validate
  end

  defp process_config_file(%{config_file: config_file}) do
    config_file
    |> Path.expand
    |> File.read
    |> process_config
  end

  defp process_config({:ok, config}) do
    config |> String.split("\n") |> parse_list
  end

  defp process_config({:error, _} = error) do
    {:ok, %{}}
  end

  defp parse_list(list, config \\ %{})

  defp parse_list([line|lines], config) do
    new_config = Map.merge config, line |> parse_line
    parse_list(lines, new_config)
  end

  defp parse_list([], config) do
    {:ok, config}
  end

  defp parse_line("") do
    %{}
  end

  defp parse_line(line) do
    [k, v] = line |> String.split(":")
    %{} |> Map.put (k |> String.strip |> String.to_atom) , (v |> String.strip)
  end

  defp merge_env_options({:ok, options}) do
    options |> EnvOptions.merge
  end

  defp merge_env_options({:error, _}= error) do
    error
  end

  defp parse_args(args) do
      {options_list, list, _invalid_options} = OptionParser.parse(
        args,
        switches: [
          api_key: :string,
          secret: :string,
          cloud_name: :string,
          config_file: :string,
          version: :boolean,
          help: :boolean,
        ],
        aliases: [
          c: :config_file,
          v: :version,
          h: :help,
        ]
      )

      options = options_list |> Enum.into %{} |> add_default_config_file_if_missing
      {options, list}
    end


    defp add_default_config_file_if_missing(%{config_file: file}=options) do
      options
    end

    defp add_default_config_file_if_missing(options) do
      options |> Map.merge %{config_file: "~/.cloudex.conf"}
    end

    defp merge_cli_options({:error, _}=error, _cli_options) do
      error
    end

    defp merge_cli_options(options, cli_options) do
      Map.merge options, cli_options
    end

    defp validate(%{api_key: api_key, secret: secret, cloud_name: cloud_name} = options) when is_binary(api_key) and is_binary(secret) and is_binary(cloud_name) do
      {:ok, options}
    end

    defp validate(options) do
      {:error, ~s<
We received the following options which are incorrect :

#{inspect options}.

To solve this please check the following :

* Make sure your config file #{options[:config_file]} exists.
* Make sure you config file contains the following settings :

api_key: YOU_CLOUDINARY_API_KEY
secret: YOU_CLOUDINARY_SECRET
cloud_name: YOU_CLOUDINARY_CLOUD_NAME

* Or set the following ENV vars :

CLOUDEX_API_KEY
CLOUDEX_SECRET
CLOUDEX_CLOUD_NAME

* Or give these settings with the command like, for example :

cloudex --api-key=YOU_CLOUDINARY_API_KEY --secret=YOU_CLOUDINARY_SECRET --cloud-name=YOU_CLOUDINARY_CLOUD_NAME ./image.jpg

>}
    end
end