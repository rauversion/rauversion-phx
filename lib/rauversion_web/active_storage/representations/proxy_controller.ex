# frozen_string_literal: true

# Proxy files through application. This avoids having a redirect and makes files easier to cache.
# class ActiveStorage::Representations::ProxyController < ActiveStorage::Representations::BaseController
#   include ActiveStorage::SetHeaders
#
#   def show
#     http_cache_forever public: true do
#       set_content_headers_from @representation.image
#       stream @representation
#     end
#   end
# end

defmodule RauversionWeb.ActiveStorage.Representations.ProxyController do
  use RauversionWeb, :controller

  action_fallback RauversionWeb.FallbackController

  # def show
  #   http_cache_forever public: true do
  #     set_content_headers_from @representation.image
  #     stream @representation
  #   end
  # end
end
