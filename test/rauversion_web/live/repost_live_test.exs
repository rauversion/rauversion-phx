defmodule RauversionWeb.RepostLiveTest do
  use RauversionWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rauversion.RepostsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_repost(_) do
    repost = repost_fixture()
    %{repost: repost}
  end

  describe "Index" do
    setup [:create_repost]

    test "lists all reposts", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.repost_index_path(conn, :index))

      assert html =~ "Listing Reposts"
    end

    test "saves new repost", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.repost_index_path(conn, :index))

      assert index_live |> element("a", "New Repost") |> render_click() =~
               "New Repost"

      assert_patch(index_live, Routes.repost_index_path(conn, :new))

      assert index_live
             |> form("#repost-form", repost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repost-form", repost: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repost_index_path(conn, :index))

      assert html =~ "Repost created successfully"
    end

    test "updates repost in listing", %{conn: conn, repost: repost} do
      {:ok, index_live, _html} = live(conn, Routes.repost_index_path(conn, :index))

      assert index_live |> element("#repost-#{repost.id} a", "Edit") |> render_click() =~
               "Edit Repost"

      assert_patch(index_live, Routes.repost_index_path(conn, :edit, repost))

      assert index_live
             |> form("#repost-form", repost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repost-form", repost: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repost_index_path(conn, :index))

      assert html =~ "Repost updated successfully"
    end

    test "deletes repost in listing", %{conn: conn, repost: repost} do
      {:ok, index_live, _html} = live(conn, Routes.repost_index_path(conn, :index))

      assert index_live |> element("#repost-#{repost.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#repost-#{repost.id}")
    end
  end

  describe "Show" do
    setup [:create_repost]

    test "displays repost", %{conn: conn, repost: repost} do
      {:ok, _show_live, html} = live(conn, Routes.repost_show_path(conn, :show, repost))

      assert html =~ "Show Repost"
    end

    test "updates repost within modal", %{conn: conn, repost: repost} do
      {:ok, show_live, _html} = live(conn, Routes.repost_show_path(conn, :show, repost))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Repost"

      assert_patch(show_live, Routes.repost_show_path(conn, :edit, repost))

      assert show_live
             |> form("#repost-form", repost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#repost-form", repost: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repost_show_path(conn, :show, repost))

      assert html =~ "Repost updated successfully"
    end
  end
end
