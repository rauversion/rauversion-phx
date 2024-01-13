defmodule Rauversion.Checks.CheckFFMPEG do
  def run() do
    case System.find_executable("ffmpeg") do
      nil ->
        {:error, "'ffmpeg' command not found on the system. Please install it to proceed."}

      _path ->
        {:ok, "'ffmpeg' command is available on the system."}
    end
  end
end

defmodule Mix.Tasks.Check do
  use Mix.Task

  alias Rauversion.Checks.CheckFFMPEG

  defp is_ok({:ok, message}) do
    Mix.shell().info(message)
  end

  defp is_ok({:error, reason}) do
    Mix.raise(reason)
  end

  @shortdoc "Check if deps versions are met."
  def run(_args) do
    is_ok(CheckFFMPEG.run())
  end
end
