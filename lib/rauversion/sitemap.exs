defmodule Rauversion.Sitemap do
  alias Rauversion.{Tracks}
  alias RauversionWeb.{Endpoint, Router.Helpers}

  use Sitemap,
    compress: false,
    host: "https://#{Application.get_env(:rauversion, Endpoint)[:url][:host]}",
    files_path: "priv/static/sitemaps/"

  def generate do
    create do
      for product <- Tracks.list_public_tracks() do
        add(Helpers.track_path(Endpoint, :show, product.slug),
          lastmod: product.updated_at,
          changefreq: "daily"
        )
      end

      ping()
    end
  end
end

Rauversion.Sitemap.generate()
