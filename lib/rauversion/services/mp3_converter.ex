defmodule Rauversion.Services.Mp3Converter do
  def run(file) do
    {:ok, dir_path} = Temp.mkdir("my-dir")

    o = "#{dir_path}/#{Path.basename(file)}"

    {output, _status} =
      System.cmd(audiowaveform_path(), [
        file,
        o
      ])

    o
  end

  def audiowaveform_path() do
    "lame"
  end
end
