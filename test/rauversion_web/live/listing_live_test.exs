defmodule RauversionWeb.ListingLiveTest do
  use RauversionWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rauversion.ListingsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_listing(_) do
    listing = listing_fixture()
    %{listing: listing}
  end

  describe "Index" do
    setup [:create_listing]

    test "lists all listings", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.listing_index_path(conn, :index))

      assert html =~ "Listing Listings"
    end

    test "saves new listing", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.listing_index_path(conn, :index))

      assert index_live |> element("a", "New Listing") |> render_click() =~
               "New Listing"

      assert_patch(index_live, Routes.listing_index_path(conn, :new))

      assert index_live
             |> form("#listing-form", listing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#listing-form", listing: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.listing_index_path(conn, :index))

      assert html =~ "Listing created successfully"
    end

    test "updates listing in listing", %{conn: conn, listing: listing} do
      {:ok, index_live, _html} = live(conn, Routes.listing_index_path(conn, :index))

      assert index_live |> element("#listing-#{listing.id} a", "Edit") |> render_click() =~
               "Edit Listing"

      assert_patch(index_live, Routes.listing_index_path(conn, :edit, listing))

      assert index_live
             |> form("#listing-form", listing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#listing-form", listing: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.listing_index_path(conn, :index))

      assert html =~ "Listing updated successfully"
    end

    test "deletes listing in listing", %{conn: conn, listing: listing} do
      {:ok, index_live, _html} = live(conn, Routes.listing_index_path(conn, :index))

      assert index_live |> element("#listing-#{listing.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#listing-#{listing.id}")
    end
  end

  describe "Show" do
    setup [:create_listing]

    test "displays listing", %{conn: conn, listing: listing} do
      {:ok, _show_live, html} = live(conn, Routes.listing_show_path(conn, :show, listing))

      assert html =~ "Show Listing"
    end

    test "updates listing within modal", %{conn: conn, listing: listing} do
      {:ok, show_live, _html} = live(conn, Routes.listing_show_path(conn, :show, listing))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Listing"

      assert_patch(show_live, Routes.listing_show_path(conn, :edit, listing))

      assert show_live
             |> form("#listing-form", listing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#listing-form", listing: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.listing_show_path(conn, :show, listing))

      assert html =~ "Listing updated successfully"
    end
  end
end
