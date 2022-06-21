defmodule Rauversion.PeaksGeneratorTest do
  use Rauversion.DataCase

  alias Rauversion.Playlists

  describe "peaks generator" do
    test "peaks gen" do
      assert [hd | rest] =
               Rauversion.Services.PeaksGenerator.run_audiowaveform("./test/files/audio.mp3", 3)

      IO.inspect(rest)
      IO.inspect("qty: #{rest |> length}")
    end

    test "peaks gen ffprobe" do
      a = Rauversion.Services.PeaksGenerator.run_ffprobe("./test/files/audio.mp3", 3)
      require IEx
      IEx.pry()
    end

    test "desired pixels" do
      desired_pixels = 500
      duration = 3600

      pixels_per_second =
        Rauversion.Services.PeaksGenerator.desired_pixels_per_second(desired_pixels, duration)

      require IEx
      IEx.pry()
    end
  end
end
