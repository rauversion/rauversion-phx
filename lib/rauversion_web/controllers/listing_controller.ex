defmodule RauversionWeb.ListingController do
  use RauversionWeb, :controller

  alias Rauversion.Listings

  def index(conn, _params) do
    listings = Listings.list_listings()
    render(conn, "index.html", listings: listings)
  end

  # def new(conn, _params) do
  #  changeset = Listings.change_listing(%Listing{})
  #  render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"listing" => listing_params}) do
  #  case Listings.create_listing(listing_params) do
  #    {:ok, listing} ->
  #      conn
  #      |> put_flash(:info, "Listing created successfully.")
  #      |> redirect(to: Routes.listing_path(conn, :show, listing))

  #    {:error, %Ecto.Changeset{} = changeset} ->
  #      render(conn, "new.html", changeset: changeset)
  #  end
  # end

  # def show(conn, %{"id" => id}) do
  #  listing = Listings.get_listing!(id)
  #  render(conn, "show.html", listing: listing)
  # end
end
