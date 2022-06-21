defmodule Rauversion.Services.Mp3Converter do
  def run(file) do
    {:ok, dir_path} = Temp.mkdir("my-dir")

    filename = file |> Path.basename(Path.extname(file))

    o = "#{dir_path}/#{Path.basename(filename)}.mp3"

    {output, _status} =
      System.cmd(ffmpeg_path(), [
        "-i",
        file,
        "-vn",
        "-ar",
        "44100",
        "-ac",
        "2",
        "-b:a",
        "192k",
        o
      ])

    # cmd =
    #  "#{ffmpeg_path()} -i input.wav -vn -ar 44100 -ac 2 -b:a 192k #{o}"
    #  |> to_charlist()

    # IO.inspect(cmd)
    # output = :os.cmd(cmd)

    IO.inspect(output)

    IO.inspect("OUTPUT EXISTS? #{File.exists?(o)}")

    o
  end

  def ffmpeg_path() do
    "ffmpeg"
  end
end
