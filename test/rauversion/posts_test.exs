defmodule Rauversion.PostsTest do
  use Rauversion.DataCase

  alias Rauversion.Posts

  describe "post" do
    alias Rauversion.Posts.Post

    import Rauversion.PostsFixtures

    @invalid_attrs %{body: nil, excerpt: nil, slug: nil, state: nil, title: nil}

    test "list_posts/0 returns all post" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{
        body: %{},
        excerpt: "some excerpt",
        slug: "some slug",
        state: "some state",
        title: "some title"
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.body == %{}
      assert post.excerpt == "some excerpt"
      assert post.slug == "some slug"
      assert post.state == "some state"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        body: %{},
        excerpt: "some updated excerpt",
        slug: "some updated slug",
        state: "some updated state",
        title: "some updated title"
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.body == %{}
      assert post.excerpt == "some updated excerpt"
      assert post.slug == "some updated slug"
      assert post.state == "some updated state"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
