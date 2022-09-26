defmodule Rauversion.PeaksGeneratorTest do
  use Rauversion.DataCase

  # alias Rauversion.Playlists

  describe "peaks generator" do
    @tag skip: "this test is incomplete - decide on final biz logic and assert"
    test "peaks gen with audiowebsurfer" do
      assert [_hd | rest] =
               Rauversion.Services.PeaksGenerator.run_audiowaveform("./test/files/audio.mp3", 3)

      IO.inspect(rest)
      IO.inspect("qty: #{rest |> length}")
    end

    test "peaks gen ffprobe" do
      assert [_ | _] = Rauversion.Services.PeaksGenerator.run_ffprobe("./test/files/audio.mp3", 3)
    end

    test "desired pixels" do
      desired_pixels = 500
      duration = 3600

      Rauversion.Services.PeaksGenerator.desired_pixels_per_second(desired_pixels, duration)
    end
  end
end
