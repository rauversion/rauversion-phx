defmodule Rauversion.UserFollowsTest do
  use Rauversion.DataCase

  alias Rauversion.UserFollows

  describe "user_follows" do
    alias Rauversion.UserFollows.UserFollow

    import Rauversion.UserFollowsFixtures
    import Rauversion.AccountsFixtures

    @invalid_attrs %{
      follower_id: nil,
      following_id: nil
    }

    test "list_user_follows/0 returns all user_follows" do
      user1 = user_fixture()
      user2 = user_fixture()

      user_follow =
        user_follow_fixture(%{
          follower_id: user1.id,
          following_id: user2.id
        })

      assert UserFollows.list_user_follows() == [user_follow]
    end

    test "get_user_follow!/1 returns the user_follow with given id" do
      user1 = user_fixture()
      user2 = user_fixture()

      user_follow =
        user_follow_fixture(%{
          follower_id: user1.id,
          following_id: user2.id
        })

      assert UserFollows.get_user_follow!(user_follow.id) == user_follow
    end

    test "create_user_follow/1 with valid data creates a user_follow" do
      user1 = user_fixture()
      user2 = user_fixture()

      valid_attrs = %{
        follower_id: user1.id,
        following_id: user2.id
      }

      assert {:ok, %UserFollow{} = user_follow} = UserFollows.create_user_follow(valid_attrs)
    end

    test "create_user_follow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserFollows.create_user_follow(@invalid_attrs)
    end

    test "update_user_follow/2 with valid data updates the user_follow" do
      user1 = user_fixture()
      user2 = user_fixture()

      user_follow =
        user_follow_fixture(%{
          follower_id: user1.id,
          following_id: user2.id
        })

      update_attrs = %{}

      assert {:ok, %UserFollow{} = user_follow} =
               UserFollows.update_user_follow(user_follow, update_attrs)
    end

    test "update_user_follow/2 with invalid data returns error changeset" do
      user1 = user_fixture()
      user2 = user_fixture()

      user_follow =
        user_follow_fixture(%{
          follower_id: user1.id,
          following_id: user2.id
        })

      assert {:error, %Ecto.Changeset{}} =
               UserFollows.update_user_follow(user_follow, @invalid_attrs)

      assert user_follow == UserFollows.get_user_follow!(user_follow.id)
    end

    test "delete_user_follow/1 deletes the user_follow" do
      user1 = user_fixture()
      user2 = user_fixture()

      user_follow =
        user_follow_fixture(%{
          follower_id: user1.id,
          following_id: user2.id
        })

      assert {:ok, %UserFollow{}} = UserFollows.delete_user_follow(user_follow)
      assert_raise Ecto.NoResultsError, fn -> UserFollows.get_user_follow!(user_follow.id) end
    end

    test "change_user_follow/1 returns a user_follow changeset" do
      user1 = user_fixture()
      user2 = user_fixture()

      user_follow =
        user_follow_fixture(%{
          follower_id: user1.id,
          following_id: user2.id
        })

      assert %Ecto.Changeset{} = UserFollows.change_user_follow(user_follow)
    end
  end
end
