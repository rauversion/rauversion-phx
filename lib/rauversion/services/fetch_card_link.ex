defmodule Rauversion.Services.FetchCardLink do
  alias Rauversion.PreviewCards

  # return preview from db cache
  def call(url) do
    case PreviewCards.find_by_url(url) do
      nil ->
        handle_fetch(url)

      record ->
        # IO.puts("RETURN FROM DB")
        record
    end
  end

  defp handle_fetch(url) do
    # "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    case OEmbed.for(url) do
      {:ok, result} -> process_oembed(result, url)
      _ -> attempt_opengraph(url)
    end
  end

  defp process_oembed(result, url) do
    Rauversion.PreviewCards.find_or_create(%{
      url: url,
      title: result.title,
      html: result.html,
      author_name: result.author_name,
      author_url: result.author_url,
      image: result.thumbnail_url
    })
  end

  defp attempt_opengraph(url) do
    cli = client("user_token")
    {:ok, conn} = cli |> Tesla.get(url)
    {:ok, document} = Floki.parse_document(conn.body)

    og_title = meta_property(document, "meta[property=\"og:title\"]")
    og_description = meta_property(document, "meta[property=\"og:description\"]")
    og_image = meta_property(document, "meta[property=\"og:image\"]")
    # IO.inspect(og_title)
    # IO.inspect(og_description)
    # IO.inspect(og_image)

    PreviewCards.find_or_create(%{
      url: url,
      title: og_title,
      description: og_description,
      image: og_image
    })

    # if og_image do
    #  image = download_image(og_image)
    #  IO.puts("olii image")
    #  IO.inspect(image)
    #  IO.puts("###")

    #  pc =
    #    Rauversion.PreviewCards.find_or_create(%{
    #      url: url,
    #      title: og_title,
    #      description: og_description,
    #      image: image
    #    })

    #  IO.inspect(pc)
    # end
  end

  defp meta_property(document, meta) do
    # "meta[property=\"og:title\"]"
    Floki.find(document, meta) |> Floki.attribute("content") |> List.first()
  end

  defp download_image(url) do
    IO.puts("downloading #{url}")
    # Application.ensure_all_started :inets
    # {:ok, resp} = :httpc.request(:get, {url, []}, [], [body_format: :binary])
    # {{_, 200, 'OK'}, _headers, body} = resp

    # IO.inspect body
    # File.write!(path, body)
    # %{file_name: "my_image.jpb", path: path }
    url
    # path = "/tmp/my_image22.jpg"
    # Waffle.File.new(url, Rauversion.PreviewCardUploader)
  end

  # build dynamic client based on runtime arguments
  defp client(_token, domain \\ "https://app.Rauversion.io") do
    middleware = [
      {Tesla.Middleware.BaseUrl, domain}
      # Tesla.Middleware.JSON,
      # {Tesla.Middleware.Headers, [{"authorization", "token: " <> token }]}
    ]

    Tesla.client(middleware)
  end
end
