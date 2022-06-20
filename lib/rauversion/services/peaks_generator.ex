defmodule Rauversion.Services.PeaksGenerator do
  def run(file) do
    {output, _status} =
      System.cmd(audiowaveform_path(), [
        "-i",
        file,
        "--pixels-per-second",
        "100",
        "--output-format",
        "json",
        "-"
      ])

    IO.inspect(output)

    frames = Jason.decode!(output)["data"]

    # audiowaveform -i ~/Desktop/patio/STE-098.mp3

    # audiowaveform -i /root/audio.mp3 --pixels-per-second 100 --output-format json -
  end

  def audiowaveform_path() do
    "audiowaveform"
  end
end
