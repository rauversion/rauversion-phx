defmodule RauversionWeb.Router do
  use RauversionWeb, :router

  import RauversionWeb.UserAuth

  import Plug.BasicAuth

  pipeline :bauth do
    plug :basic_auth, username: "rau", password: "raurocks"
  end

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RauversionWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug RauversionWeb.Plugs.SetLocale
  end

  # without protect_from_forgery
  pipeline :browser_unprotected do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RauversionWeb.LayoutView, :root}
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug RauversionWeb.Plugs.SetLocale
  end

  pipeline :active_storage do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    # plug :fetch_live_flash
    # plug :put_root_layout, {RauversionWeb.LayoutView, :root}
    plug :put_secure_browser_headers
    # plug :fetch_current_user
  end

  pipeline :browser_embed do
    plug :accepts, ["html"]
    # plug :fetch_session
    # plug :fetch_live_flash
    plug :put_secure_browser_headers
    plug :put_new_layout, {RauversionWeb.LayoutView, :embed}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_api do
    plug RemoteIp
    plug :fetch_session
    plug :fetch_current_user
    plug :accepts, ["json", "html"]
  end

  # scope "/", RauversionWeb do
  #  pipe_through :browser
  #  get "/", PageController, :index
  # end

  scope "/auth", RauversionWeb do
    pipe_through :browser

    get "/:provider", OAuthController, :request
    get "/:provider/callback", OAuthController, :callback
    get "/:provider/revoke", OAuthController, :revoke
  end

  scope "/", RauversionWeb do
    pipe_through :browser_embed
    get "/embed/:track_id", EmbedController, :show
    get "/oembed/:track_id", EmbedController, :oembed_show
    get "/oembed/:track_id/private", EmbedController, :oembed_private_show
    get "/embed/:track_id/private", EmbedController, :private

    get "/embed/sets/:playlist_id", EmbedController, :show_playlist
    get "/embed/sets/:playlist_id/private", EmbedController, :private_playlist

    post "/webhooks/stripe", WebhooksController, :create
  end

  # Other scopes may use custom stacks.
  scope "/api", RauversionWeb do
    pipe_through :browser_api
    post "/tracks/:track_id/events", TrackingEventsController, :show
    get "/tracks/:track_id/events", TrackingEventsController, :show
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test, :prod] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      pipe_through :bauth
      live_dashboard "/dashboard", metrics: RauversionWeb.Telemetry, ecto_repos: [Rauversion.Repo]
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RauversionWeb do
    pipe_through [
      :browser,
      :redirect_if_user_is_authenticated,
      :redirect_if_disabled_registrations
    ]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
  end

  scope "/", RauversionWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update

    get "/users/invite/:token", UserInvitationController, :accept
    put "/users/invite/:token/:id/invite_update", UserInvitationController, :update_user
  end

  scope "/", RauversionWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/invite", UserInvitationController, :new
    post "/users/invite", UserInvitationController, :create

    get "/webpayplus/mall/create", TbkController, :mall_create
    post "/webpayplus/mall/create", TbkController, :send_mall_create
    post "/webpayplus/mall/return_url", TbkController, :mall_commit

    post "/webpayplus/mall/events/:id/return_url", TbkController, :mall_events_commit
    get "/webpayplus/mall/events/:id/return_url", TbkController, :mall_events_commit

    get "/webpayplus/mall/return_url", TbkController, :mall_commit

    get "/webpayplus/mall/status/:token", TbkController, :mall_status
    post "/webpayplus/mall/refund", TbkController, :mall_refund

    live "/streams/:id", StreamsLive.Show, :show

    live "/tickets/qr/:signed_id", QrLive.Index, :index

    live "/users/settings", UserSettingsLive.Index, :profile
    live "/users/settings/email", UserSettingsLive.Index, :email
    live "/users/settings/security", UserSettingsLive.Index, :security
    live "/users/settings/notifications", UserSettingsLive.Index, :notifications
    live "/users/settings/integrations", UserSettingsLive.Index, :integrations
    live "/users/settings/transbank", UserSettingsLive.Index, :transbank

    get "/oembed", OEmbedController, :create

    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/articles/mine", ArticlesLive.Index, :mine
    live "/articles/new", ArticlesLive.New, :new
    live "/articles/edit/:id", ArticlesLive.New, :edit
    live "/articles/:slug/edit", ArticlesLive.New, :edit

    live "/events/mine", EventsLive.Index, :mine
    live "/events/new", EventsLive.New, :new
    live "/events/edit/:id", EventsLive.New, :edit
    live "/events/:slug/edit", EventsLive.New, :edit
    live "/events/:slug/overview", EventsLive.New, :overview

    live "/events/:slug/payment_success", EventsLive.Show, :payment_success
    live "/events/:slug/payment_failure", EventsLive.Show, :payment_fail
    live "/events/:slug/payment_cancel", EventsLive.Show, :payment_cancel

    live "/events/:slug/edit/schedule", EventsLive.New, :schedule
    live "/events/:slug/edit/tickets", EventsLive.New, :tickets
    live "/events/:slug/edit/order_form", EventsLive.New, :order_form
    live "/events/:slug/edit/widgets", EventsLive.New, :widgets
    live "/events/:slug/edit/tax", EventsLive.New, :tax
    live "/events/:slug/edit/attendees", EventsLive.New, :attendees
    live "/events/:slug/edit/sponsors", EventsLive.New, :sponsors
    live "/events/:slug/edit/hosts", EventsLive.New, :hosts

    live "/tracks/new", TrackLive.New, :new
    live "/tracks/:id/edit", TrackLive.Index, :edit

    get "/tracks/:id/oembed.xml", TracksController, :oembed

    live "/tracks/:id/show/edit", TrackLive.Show, :edit

    live "/reposts/new", RepostLive.Index, :new
    live "/reposts/:id/edit", RepostLive.Index, :edit

    live "/reposts/:id/show/edit", RepostLive.Show, :edit

    live "/playlists/new", PlaylistLive.Index, :new
    live "/playlists/:id/edit", PlaylistLive.Index, :edit
    live "/playlists/:id/show/edit", PlaylistLive.Show, :edit
  end

  scope "/active_storage", RauversionWeb do
    pipe_through [:active_storage]

    # get "/blobs/proxy/:signed_id/*filename" => "active_storage/blobs/proxy#show", as: :rails_service_blob_proxy
    get(
      "/blobs/proxy/:signed_id/*filename",
      ActiveStorage.Blobs.ProxyController,
      :show
    )

    # get "/blobs/redirect/:signed_id/*filename" => "active_storage/blobs/redirect#show", as: :rails_service_blob
    get(
      "/blobs/redirect/:signed_id/*filename",
      ActiveStorage.Blobs.RedirectController,
      :show
    )

    # get("/blobs/:signed_id/*filename", ActiveStorage.Blob.ProxyController, :show)
    # get "/blobs/:signed_id/*filename" => "active_storage/blobs/redirect#show"

    get(
      "/representations/redirect/:signed_blob_id/:variation_key/*filename",
      ActiveStorage.Representations.RedirectController,
      :show
    )

    get(
      "/representations/proxy/:signed_blob_id/:variation_key/*filename",
      ActiveStorage.Representations.ProxyController,
      :show
    )

    # get "/representations/redirect/:signed_blob_id/:variation_key/*filename" => "active_storage/representations/redirect#show", as: :rails_blob_representation
    # get "/representations/proxy/:signed_blob_id/:variation_key/*filename" => "active_storage/representations/proxy#show", as: :rails_blob_representation_proxy
    # get "/representations/:signed_blob_id/:variation_key/*filename" => "active_storage/representations/redirect#show"

    # get  "/disk/:encoded_key/*filename" => "active_storage/disk#show", as: :rails_disk_service
    # put  "/disk/:encoded_token" => "active_storage/disk#update", as: :update_rails_disk_service
    get(
      "/disk/:encoded_key/*filename",
      ActiveStorage.DiskController,
      :show
    )

    put(
      "/disk/:encoded_token",
      ActiveStorage.DiskController,
      :update
    )

    post(
      "/direct_uploads",
      ActiveStorage.DirectUploadsController,
      :create
    )
  end

  scope "/", RauversionWeb do
    pipe_through [:browser]

    live "/", HomeLive.Index, :index

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update

    live "/articles", ArticlesLive.Index, :index
    live "/articles/category/:id", ArticlesLive.Index, :category

    live "/articles/:id", ArticlesLive.Show, :show

    live "/events", EventsLive.Index, :index
    live "/events/:id", EventsLive.Show, :show
    live "/events/:id/tickets", TicketsLive.Index, :index

    live "/purchases/tickets", MyTicketsLive.Index, :index

    live "/tracks", TrackLive.Index, :index
    live "/tracks/:id", TrackLive.Show, :show
    live "/tracks/:id/private", TrackLive.Show, :private
    live "/reposts", RepostLive.Index, :index
    live "/reposts/:id", RepostLive.Show, :show
    live "/playlists", PlaylistLive.Index, :index
    live "/playlists/:id", PlaylistLive.Show, :show
    live "/playlists/:id/private", PlaylistLive.Show, :private

    # post "/direct_uploads" => "active_storage/direct_uploads#create", as: :rails_direct_uploads

    # get "/:username", ProfileController, :show
    live "/:username", ProfileLive.Index, :index
    live "/:username/followers", FollowsLive.Index, :followers
    live "/:username/following", FollowsLive.Index, :followings
    live "/:username/comments", FollowsLive.Index, :comments
    live "/:username/likes", FollowsLive.Index, :likes
    live "/:username/tracks/all", ProfileLive.Index, :tracks_all
    live "/:username/tracks/reposts", ProfileLive.Index, :reposts
    live "/:username/tracks/albums", ProfileLive.Index, :albums
    live "/:username/tracks/playlists", ProfileLive.Index, :playlists
    live "/:username/tracks/popular", ProfileLive.Index, :popular
    live "/:username/insights", ProfileLive.Index, :insights
  end
end
