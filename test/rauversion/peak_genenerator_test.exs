defmodule Rauversion.PeaksGeneratorTest do
  use Rauversion.DataCase

  alias Rauversion.Playlists

  describe "peaks generator" do
    test "peaks gen" do
      Rauversion.Services.PeaksGenerator.run("/Users/michelson/Desktop/patio/STE-098.mp3")
    end
  end
end
