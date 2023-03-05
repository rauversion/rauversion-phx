# frozen_string_literal: true

# class ActiveStorage::Blobs::ProxyController < ActiveStorage::BaseController
#   include ActiveStorage::SetBlob
#   include ActiveStorage::Streaming
#
#   def show
#     if request.headers["Range"].present?
#       send_blob_byte_range_data @blob, request.headers["Range"]
#     else
#       http_cache_forever public: true do
#         response.headers["Accept-Ranges"] = "bytes"
#         response.headers["Content-Length"] = @blob.byte_size.to_s
#
#         send_blob_stream @blob, disposition: params[:disposition]
#       end
#     end
#   end
# end

defmodule RauversionWeb.ActiveStorage.Blobs.ProxyController do
  use RauversionWeb, :controller

  # action_fallback RauversionWeb.FallbackController

  def show(conn, %{"signed_id" => signed_id}) do
    case conn |> handle_action(signed_id) do
      %{assigns: %{blob: _blob}} = conn ->
        handle_range_request(conn)

      _ ->
        conn
    end
  end

  def handle_range_request(conn = %{assigns: %{blob: blob}}) do
    req_range_header = Plug.Conn.get_req_header(conn, "range")

    case has_range_header(req_range_header) do
      true ->
        case parse_range(req_range_header) do
          {0, 1} = range ->
            send_range(conn, range)

          {0, -1} ->
            range = {0, conn.assigns.blob.byte_size}
            send_range(conn, range)

          {range_start, -1} ->
            range = {range_start, conn.assigns.blob.byte_size}
            send_range(conn, range)

          {_range_start, _range_end} = range ->
            send_range(conn, range)

          ranges when is_list(ranges) ->
            send_multipart_ranges(conn, ranges)

          _ ->
            conn
            |> Plug.Conn.send_resp(422, "not found")
        end

      _ ->
        # http_cache_forever public: true do
        #         response.headers["Accept-Ranges"] = "bytes"
        #         response.headers["Content-Length"] = @blob.byte_size.to_s
        #
        #         send_blob_stream @blob, disposition: params[:disposition]
        #       end

        # disposition: params[:disposition]

        conn
        # this is cache forever!
        |> Plug.Conn.put_resp_header("cache-control", "max-age=#{3_155_760_000}, public")
        |> Plug.Conn.put_resp_header("accept-ranges", "bytes")
        |> Plug.Conn.put_resp_header("content-length", conn.assigns.blob.byte_size |> to_string)
        |> Plug.Conn.put_resp_header(
          "content-disposition",
          ~s(inline; filename="#{ActiveStorage.Blob.filename(conn.assigns.blob).filename}")
        )
        |> send_blob_stream(blob)
    end
  end

  def send_range(conn, range) do
    blob = conn.assigns.blob
    service = blob |> ActiveStorage.Blob.service()

    data = service.__struct__.download_chunk(service, blob.key, range)
    {range_start, range_end} = range
    filename = blob |> ActiveStorage.Blob.filename()

    conn
    # |> Plug.Conn.put_resp_header("content-length", Integer.to_string(content_length))
    |> Plug.Conn.put_resp_header("accept-ranges", "bytes")
    |> Plug.Conn.put_resp_header(
      "content-disposition",
      ~s(inline; filename="#{filename.filename}")
    )
    |> Plug.Conn.put_resp_header("content-type", blob.content_type)
    |> Plug.Conn.put_resp_header(
      "content-range",
      "bytes #{range_start}-#{blob.byte_size - 1}/#{blob.byte_size}"
    )
    |> Plug.Conn.send_resp(:partial_content, data)

    # |> Plug.Conn.send_file(206, video_path, offset, file_size - offset)
  end

  def send_multipart_ranges(conn, ranges) do
    blob = conn.assigns.blob
    filename = blob |> ActiveStorage.Blob.filename()
    service = blob |> ActiveStorage.Blob.service()
    content_type_for_serving = blob.content_type

    boundary = :crypto.strong_rand_bytes(16) |> :base64.encode_to_string() |> to_string

    content_type = "multipart/byteranges; boundary=#{boundary}"

    data =
      Enum.reduce(ranges, "", fn range, acc ->
        {range_start, range_end} = range

        chunk = service.__struct__.download_chunk(service, blob.key, range)

        acc
        |> Kernel.<>("\r\n--#{boundary}\r\n")
        # |> Kernel.<>("Content-Type: #{blob.content_type_for_serving}\r\n")
        |> Kernel.<>("Content-Type: #{content_type_for_serving}\r\n")
        |> Kernel.<>("Content-Range: bytes #{range_start}-#{range_end}/#{blob.byte_size}\r\n\r\n")
        |> Kernel.<>(chunk)
      end)
      |> Kernel.<>("\r\n--#{boundary}--\r\n")

    conn
    |> Plug.Conn.put_resp_header("accept-ranges", "bytes")
    |> Plug.Conn.put_resp_header("content-length", byte_size(data) |> to_string)
    |> Plug.Conn.put_resp_header(
      "content-disposition",
      ~s(inline; filename="#{filename.filename}")
    )
    # |> Plug.Conn.put_resp_header("content-type", "text/plain")
    |> Plug.Conn.send_resp(:partial_content, data)
  end

  def handle_action(conn, signed_id) do
    case ActiveStorage.Verifier.verify(signed_id) do
      {:ok, id} ->
        conn |> find_blob(id)

      _ ->
        conn
        |> Plug.Conn.send_resp(422, "not found")
        |> Plug.Conn.halt()
    end
  end

  defp find_blob(conn, id) do
    case ActiveStorage.get_storage_blob!(id) do
      nil ->
        conn
        |> Plug.Conn.send_resp(:not_found, "not found")
        |> Plug.Conn.halt()

      blob ->
        conn |> assign(:blob, blob)
    end
  end

  defp has_range_header(req_range_header) do
    # IO.inspect(req_range_header)

    case req_range_header do
      # TODO think about multi ranges
      [_ | _] -> true
      [] -> false
      _ -> false
    end
  end

  def parse_range(req_range_header) do
    [x | _] = req_range_header
    range = x |> String.trim_leading("bytes=")

    ranges =
      range
      |> String.split(",")

    cond do
      ranges |> length() > 1 ->
        ranges
        |> Enum.map(fn x ->
          handle_range(x)
        end)

      ranges |> length() == 1 ->
        ranges |> List.first() |> handle_range()
    end
  end

  def handle_range(range) do
    [range_start, range_end] = String.split(range, "-")

    case range_end == "" do
      true -> {String.to_integer(range_start), -1}
      false -> {String.to_integer(range_start), String.to_integer(range_end)}
    end
  end

  def send_blob_stream(conn, blob, options \\ []) do
    defaults = [disposition: nil]
    options = Keyword.merge(defaults, options)

    conn =
      conn
      |> put_resp_content_type(blob.content_type)
      |> send_chunked(200)

    downloaded_stream =
      ActiveStorage.Blob.download(blob, fn chunk_data ->
        # IO.inspect(chunk_data)
        # IO.inspect("chunk_data: !!")
        chunk(conn, chunk_data)
      end)

    case downloaded_stream do
      {:ok, conn} ->
        conn

      _ ->
        conn
    end

    # send_stream(
    #    filename: blob.filename.sanitized,
    #    disposition: blob.forced_disposition_for_serving || disposition || DEFAULT_BLOB_STREAMING_DISPOSITION,
    #    type: blob.content_type_for_serving) do |stream|
    #  blob.download do |chunk|
    #    stream.write chunk
    #  end
    # end
  end
end
