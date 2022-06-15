defmodule RauversionWeb.Router do
  use RauversionWeb, :router

  import RauversionWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RauversionWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RauversionWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RauversionWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RauversionWeb.Telemetry
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
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", RauversionWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/listings", ListingController

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/tracks", TrackLive.Index, :index
    live "/tracks/new", TrackLive.New, :new
    live "/tracks/:id/edit", TrackLive.Index, :edit

    live "/tracks/:id", TrackLive.Show, :show
    live "/tracks/:id/show/edit", TrackLive.Show, :edit

    live "/reposts", RepostLive.Index, :index
    live "/reposts/new", RepostLive.Index, :new
    live "/reposts/:id/edit", RepostLive.Index, :edit

    live "/reposts/:id", RepostLive.Show, :show
    live "/reposts/:id/show/edit", RepostLive.Show, :edit

    live "/playlists", PlaylistLive.Index, :index
    live "/playlists/new", PlaylistLive.Index, :new
    live "/playlists/:id/edit", PlaylistLive.Index, :edit

    live "/playlists/:id", PlaylistLive.Show, :show
    live "/playlists/:id/show/edit", PlaylistLive.Show, :edit

    # get "/:username", ProfileController, :show
    live "/:username", ProfileLive.Index, :index
    live "/:username/tracks/all", ProfileLive.Index, :tracks_all
    live "/:username/tracks/reposts", ProfileLive.Index, :reposts
    live "/:username/tracks/albums", ProfileLive.Index, :albums
    live "/:username/tracks/playlists", ProfileLive.Index, :playlists
  end

  scope "/", RauversionWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
