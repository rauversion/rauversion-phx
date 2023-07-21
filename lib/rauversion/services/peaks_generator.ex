defmodule Rauversion.Services.PeaksGenerator do
  def run_audiowaveform(file, duration) do
    desired_pixels = 10

    # desired_pixels_per_second(desired_pixels, duration)
    pixels_per_second = calculate_pixels_per_second(duration)

    IO.inspect("pixels_per_second: #{pixels_per_second}")

    case System.cmd(audiowaveform_path(), [
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
         ]) do
      {output, _status} ->
        IO.inspect(output)

        output
        |> Jason.decode!()
        |> get_in(["data"])
        |> normalize

      _ ->
        []
    end

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

    # IO.inspect(output)

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

  def calculate_pixels_per_second(duration_in_seconds, desired_waveform_width \\ 800) do
    :erlang.integer_to_binary(round(desired_waveform_width / duration_in_seconds))
  end

  def desired_pixels_per_second(desired_pixels, duration) do
    pixels_per_second =
      (desired_pixels / duration)
      |> round

    cond do
      pixels_per_second < 0 -> 1
      pixels_per_second == 0 -> 1
      true -> 200
    end
  end

  def normalize(input) do
    {min, max} = Enum.min_max(input)
    {new_min, new_max} = {-1.0, 1.0}

    Enum.map(
      input,
      &((new_min + (&1 - min) / (max - min) * (new_max - new_min))
        |> Decimal.from_float()
        |> Decimal.round(3)
        |> Decimal.to_float())
    )
  end

  def ffprobe_path() do
    "ffprobe"
  end

  def audiowaveform_path() do
    "audiowaveform"
  end

  def run(file, duration) do
    case Application.get_env(:rauversion, :peaks_processor) do
      "audiowaveform" ->
        run_audiowaveform(file, duration)

      _ ->
        run_ffprobe(file, duration)
    end
  end
end
