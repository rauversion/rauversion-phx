defmodule RauversionWeb.ActiveStorage.Blobs.ProxyControllerTest do
  use RauversionWeb.ConnCase

  test "GET /", %{conn: conn} do
    blob = ActiveStorageTestHelpers.create_file_blob(filename: "text.md")

    signed_id = blob |> ActiveStorage.Blob.signed_id()
    filename = blob |> ActiveStorage.Blob.filename()

    conn =
      conn
      |> put_req_header("range", "bytes=0-")
      |> get("/active_storage/blobs/proxy/#{signed_id}/#{filename.filename}")

    assert response(conn, 206) =~ "Hello World!"
  end

  test "serves requested range of file starting from byte 0", %{conn: conn} do
    blob = ActiveStorageTestHelpers.create_file_blob(filename: "text.md")
    signed_id = blob |> ActiveStorage.Blob.signed_id()
    filename = blob |> ActiveStorage.Blob.filename()

    conn =
      conn
      |> put_req_header("range", "bytes=0-1")
      |> get("/active_storage/blobs/proxy/#{signed_id}/#{filename.filename}")

    assert response(conn, 206) == "H"
  end

  test "serves requested range of file starting from byte 0 multi", %{conn: conn} do
    blob = ActiveStorageTestHelpers.create_file_blob(filename: "text.md")

    signed_id = blob |> ActiveStorage.Blob.signed_id()
    filename = blob |> ActiveStorage.Blob.filename()

    conn =
      conn
      |> put_req_header("range", "bytes=5-9,13-17")
      |> get("/active_storage/blobs/proxy/#{signed_id}/#{filename.filename}")

    assert response(conn, 206) =~ "World!"
  end

  test "range split" do
    range = ["bytes=5-9,13-17"]
    _size = "1124062"

    assert [{5, 9}, {13, 17}] ==
             RauversionWeb.ActiveStorage.Blobs.ProxyController.parse_range(range)
  end
end
