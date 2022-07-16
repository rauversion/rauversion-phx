defmodule Rauversion.Services.Mp3ConverterTest do
  use Rauversion.DataCase

  # alias Rauversion.Playlists

  describe "peaks generator" do
    test "peaks gen" do
      a = Rauversion.Services.Mp3Converter.run("./test/files/audio.mp3")
      IO.inspect(a)
    end
  end
end
