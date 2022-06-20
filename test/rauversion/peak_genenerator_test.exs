defmodule Rauversion.PeaksGeneratorTest do
  use Rauversion.DataCase

  alias Rauversion.Playlists

  describe "peaks generator" do
    test "peaks gen" do
      assert [hd | rest] = Rauversion.Services.PeaksGenerator.run("./test/files/audio.mp3")
      IO.inspect("qty: #{rest |> length}")
    end

    test "peaks gen ffprobe" do
      a = Rauversion.Services.PeaksGenerator.run_ffprobe("./test/files/audio.mp3")
      require IEx
      IEx.pry()
    end
  end
end
