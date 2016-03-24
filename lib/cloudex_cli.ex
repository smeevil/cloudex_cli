defmodule CloudexCli do
  alias CloudexCli.ConfigParser
  def main(args) do
    case ConfigParser.parse(args) do
      {:ok, %{config: config, list: list}} -> boot_and_process(config, list)
      {:error, message} -> IO.puts message
    end
  end

  defp boot_and_process(config, list) do
    boot = config |> Cloudex.start
    case boot do
      {:error, :invalid_settings} -> settings_help
      {:error, message}           -> IO.puts message
      {:ok, _}                    -> process(config, list)
      _                           -> IO.puts "Something went horribly wrong ! #{inspect boot}"
    end
  end

  defp process(_options, []) do
    help
  end

  defp process(%{help: _}, _list) do
    help
  end

  defp process(%{version: _}, _list) do
    IO.puts "Cloudex 0.1"
    IO.puts ""
  end

  defp process(_options, list) do
    list |> Cloudex.upload |> print
  end

  defp help do
    IO.puts ""
    IO.puts "Cloudex is a CLI tool to upload image files or urls to cloudinary."
    IO.puts "------------------------------------------------------------------"
    IO.puts "Usage : "
    IO.puts "cloudex image1.jpg ./image2.png /tmp/image3.gif http://example.org/image4.jpeg"
    IO.puts "cloudex ."
  end

  defp settings_help do
    IO.puts ""
    IO.puts "We could not find valid settings to operate with, to fix this you can do one of the following :"
    IO.puts ""
    IO.puts "----------------------------Config File--------------------------------------"
    IO.puts "Create a config file containing the following info :"
    IO.puts "api_key: YOUR_API_KEY_HERE"
    IO.puts "secret: YOUR_SECRET_HERE"
    IO.puts "cloud_name: YOUR_CLOUD_NAME_HERE"
    IO.puts ""
    IO.puts "And save that for example in ~/.cloudex.conf, this is the default we will look for"
    IO.puts ""
    IO.puts "----------------------------CLI Options--------------------------------------"
    IO.puts "Use the cli options to put in all settings like"
    IO.puts "cloudex --api-key=YOUR_KEY_HERE --secret=YOUR_SECRET_HERE --cloud-name=YOUR_CLOUD_NAME_HERE"
    IO.puts "or if you like to use a diffent config you can use that with : "
    IO.puts "cloudex --config-file=/path/to/file.conf"
    IO.puts ""
    IO.puts "----------------------------ENV SETTINGS --------------------------------------"
    IO.puts "Set the following env settings :"
    IO.puts "CLOUDEX_API_KEY=YOUR_KEY_HERE"
    IO.puts "CLOUDEX_SECRET=YOUR_SECRET_HERE"
    IO.puts "CLOUDEX_CLOUD_NAME=YOUR_CLOUD_NAME_HERE"
    IO.puts ""
    IO.puts "----------------------------Combination of all--------------------------------------"
    IO.puts "You can mix all settings, just take note of the priority :"
    IO.puts "cli options have the highest priority"
    IO.puts "env settings will overwrite config_file settings"
    IO.puts "config_file settings have the lowest priority"
    IO.puts ""
    IO.puts "For example"
    IO.puts "CLOUDINARY_SECRET=secret_from_env cloudex --api-key=console-key ./my_image.jpg"
    IO.puts "This will use the api_key 'console-key' the secret 'secret_from_env' and the cloud_name configured in the config file (~/.cloudex.conf)"
    IO.puts ""
    IO.puts ""
  end

  defp print(results, formatted_output \\[])

  defp print([], formatted_output) do
    IO.puts Enum.join formatted_output, "\n"
  end

  defp print([result|results], formatted_output) do
    output = [handle_result(result) |formatted_output]
    print(results, output)
  end

  defp handle_result({:ok, uploaded_image}) do
    "#{uploaded_image.source} -> #{uploaded_image.url}"
  end

  defp handle_result({:error, message}) do
    message
  end

  defp handle_result(:ok) do
    #noop
  end
end
