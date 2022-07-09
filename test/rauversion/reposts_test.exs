defmodule Rauversion.RepostsTest do
  use Rauversion.DataCase

  alias Rauversion.Reposts

  describe "reposts" do
    alias Rauversion.Reposts.Repost

    import Rauversion.{
      RepostsFixtures,
      TracksFixtures,
      AccountsFixtures
    }

    @invalid_attrs %{
      user_id: nil
    }

    def valid_repost() do
      user = user_fixture(%{username: "miki"})
      track = track_fixture(%{user_id: user.id})
      repost = repost_fixture(%{user_id: user.id, track_id: track.id})
    end

    test "list_reposts/0 returns all reposts" do
      v = valid_repost()
      assert Reposts.list_reposts() == [v]
    end

    test "get_repost!/1 returns the repost with given id" do
      repost = valid_repost()
      assert Reposts.get_repost!(repost.id) == repost
    end

    test "create_repost/1 with valid data creates a repost" do
      user = user_fixture(%{username: "foo"})
      track = track_fixture(%{user_id: user.id})
      valid_attrs = %{user_id: user.id, track_id: track.id}

      assert {:ok, %Repost{} = repost} = Reposts.create_repost(valid_attrs)
    end

    test "create_repost/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reposts.create_repost(@invalid_attrs)
    end

    test "update_repost/2 with valid data updates the repost" do
      repost = valid_repost()
      update_attrs = %{}

      assert {:ok, %Repost{} = repost} = Reposts.update_repost(repost, update_attrs)
    end

    test "update_repost/2 with invalid data returns error changeset" do
      repost = valid_repost()
      assert {:error, %Ecto.Changeset{}} = Reposts.update_repost(repost, @invalid_attrs)
      assert repost == Reposts.get_repost!(repost.id)
    end

    test "delete_repost/1 deletes the repost" do
      repost = valid_repost()
      assert {:ok, %Repost{}} = Reposts.delete_repost(repost)
      assert_raise Ecto.NoResultsError, fn -> Reposts.get_repost!(repost.id) end
    end

    test "change_repost/1 returns a repost changeset" do
      repost = valid_repost()
      assert %Ecto.Changeset{} = Reposts.change_repost(repost)
    end
  end
end
