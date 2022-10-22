defmodule Rauversion.Checks.CheckFFMPEG do
  @min 500
  @min_string "5.0.0"

  def run() do
    {version, _} = System.cmd("ffmpeg", ["-version"])
    current =
      Regex.run(~r/ffmpeg version ([\S]*)/, version)
      |> Enum.at(1)

    exists? = current
    |> String.graphemes()
    |> Enum.filter(fn item -> item != "." end)
    |> Enum.join()
    |> String.to_integer()
    |> Kernel.>=(@min)

    case exists? do
      true -> true
      false -> raise "ffmpeg version #{@min_string} or greater required. Current #{current}"
    end
  end
end

defmodule Mix.Tasks.Check do
  use Mix.Task

  alias Rauversion.Checks.CheckFFMPEG

  defp is_ok(true) do
    IO.inspect "All checks passed"
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
