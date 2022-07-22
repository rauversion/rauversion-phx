defmodule Rauversion.Services.PeaksGenerator do
  # TODO: idea calculate duration to have 1000 data points
  def run_audiowaveform(file, duration) do
    desired_pixels = 500

    pixels_per_second = desired_pixels_per_second(desired_pixels, duration)

    {output, _status} =
      System.cmd(audiowaveform_path(), [
        "-i",
        file,
        "--input-format",
        "mp3",
        "--pixels-per-second",
        "#{pixels_per_second}",
        "-b",
        "8",
        "--output-format",
        "json",
        "-"
      ])

    # |> normalize
    Jason.decode!(output)["data"]

    # audiowaveform -i ~/Desktop/patio/STE-098.mp3

    # audiowaveform -i /root/audio.mp3 --pixels-per-second 100 --output-format json -
  end

  def run_ffprobe(file, duration) do
    IO.inspect("processing #{file}")

    pixels_per_frame = duration * 75

    cmd =
      "#{ffprobe_path()} -v error -f lavfi -i amovie=#{file},asetnsamples=n=#{pixels_per_frame}:p=0,astats=metadata=1:reset=1 -show_entries frame_tags=lavfi.astats.Overall.Peak_level -of json"
      |> to_charlist()

    IO.inspect(cmd)
    output = :os.cmd(cmd)

    IO.inspect(output)

    Jason.decode!(output)["frames"]
    |> Enum.map(fn x ->
      case get_in(x, ["tags", "lavfi.astats.Overall.Peak_level"]) |> Float.parse() do
        {f, _} -> f
        _ -> nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
    |> normalize
  end

  def desired_pixels_per_second(desired_pixels, duration) do
    res =
      (desired_pixels / duration)
      |> to_string
      |> Integer.parse()

    case res do
      {pixels_per_second, _} ->
        cond do
          pixels_per_second < 0 -> 1
          pixels_per_second == 0 -> 1
          true -> pixels_per_second
        end

      _ ->
        1
    end
  end

  def normalize(input) do
    {min, max} = Enum.min_max(input)
    {new_min, new_max} = {0, 1}

    Enum.map(
      input,
      &((new_min + (&1 - min) / (max - min) * (new_max - new_min))
        |> Decimal.from_float()
        |> Decimal.round(1)
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
