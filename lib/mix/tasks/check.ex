defmodule Rauversion.Checks.CheckFFMPEG do
  def run() do
    {_, status} = System.cmd("which", ["ffmpeg"])

    case status do
      0 ->
        true

      err ->
        IO.inspect err, label: "ffmpeg error"
        raise "ffmpeg command not found"
    end
  end
end

defmodule Mix.Tasks.Check do
  use Mix.Task

  alias Rauversion.Checks.CheckFFMPEG

  defp is_ok(true) do
    IO.inspect("All checks passed")
  end

  defp is_ok(_) do
    raise "Some dependencies are missing or wrongly configured."
  end

  defp check() do
    CheckFFMPEG.run()
  end

  @shortdoc "Check if deps versions are met."
  def run(_id) do
    is_ok(check())
  end
end
