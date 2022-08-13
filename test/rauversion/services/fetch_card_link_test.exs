defmodule Rauversion.FetchCardLinkTest do
  use Rauversion.DataCase

  describe "fetch card link" do
    alias Rauversion.Services.FetchCardLink

    test "youtube" do
      url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
      card = FetchCardLink.call(url)
      card2 = FetchCardLink.call(url)
      assert card == card2
    end

    test "preview card will return the same record on second fetch" do
      url = "https://github.com"
      assert FetchCardLink.call(url) == FetchCardLink.call(url)
    end
  end
end
