defmodule Rauversion.Services.PeaksGenerator do
  def run_audiowaveform(file) do
    {output, _status} =
      System.cmd(audiowaveform_path(), [
        "-i",
        file,
        "--input-format",
        "mp3",
        "--pixels-per-second",
        "1",
        "-b",
        "8",
        "--output-format",
        "json",
        "-"
      ])

    # |> normalize
    frames = Jason.decode!(output)["data"]

    # audiowaveform -i ~/Desktop/patio/STE-098.mp3

    # audiowaveform -i /root/audio.mp3 --pixels-per-second 100 --output-format json -
  end

  def run_ffprobe(file) do
    IO.inspect("processing #{file}")

    cmd =
      "#{ffprobe_path()} -v error -f lavfi -i amovie=#{file},astats=metadata=1:reset=1 -show_entries frame_tags=lavfi.astats.Overall.Peak_level -of json"
      |> to_charlist()

    IO.inspect(cmd)
    output = :os.cmd(cmd)

    frames =
      Jason.decode!(output)["frames"]
      |> Enum.map(fn x ->
        case get_in(x, ["tags", "lavfi.astats.Overall.Peak_level"]) |> Float.parse() do
          {f, _} -> f
          _ -> nil
        end
      end)
  end

  def normalize(input) do
    {min, max} = Enum.min_max(input)
    {new_min, new_max} = {0, 1}

    Enum.map(
      input,
      &((new_min + (&1 - min) / (max - min) * (new_max - new_min))
        |> Decimal.from_float()
        |> Decimal.round(4)
        |> Decimal.to_float())
    )
  end

  def ffprobe_path() do
    "ffprobe"
  end

  def audiowaveform_path() do
    "audiowaveform"
  end
end
