defmodule GSGMSWeb.Router do
  use GSGMSWeb, :router

  import GSGMSWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GSGMSWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Authentication routes

  scope "/", GSGMSWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/reset-password", UserResetPasswordController, :new
    post "/reset-password", UserResetPasswordController, :create
    get "/reset-password/:token", UserResetPasswordController, :edit
    put "/reset-password/:token", UserResetPasswordController, :update
  end

  scope "/", GSGMSWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", PageLive, :index

    live "/players", PlayerLive.Index, :index
    live "/players/new", PlayerLive.Index, :new
    live "/players/:id/edit", PlayerLive.Index, :edit
    live "/players/:id", PlayerLive.Show, :show
    live "/players/:id/show/edit", PlayerLive.Show, :edit

    live "/teams", TeamLive.Index, :index
    live "/teams/new", TeamLive.Index, :new
    live "/teams/:id/edit", TeamLive.Index, :edit
    live "/teams/:id", TeamLive.Show, :show
    live "/teams/:id/show/edit", TeamLive.Show, :edit

    get "/account/settings", UserSettingsController, :edit
    put "/account/settings/update_password", UserSettingsController, :update_password
    put "/account/settings/update_email", UserSettingsController, :update_email
    get "/account/settings/confirm_email/:token", UserSettingsController, :confirm_email

    # live "/users", UserLive.Index, :index
    # live "/users/new", UserLive.Index, :new
    # live "/users/:id/edit", UserLive.Index, :edit
    # live "/users/:id", UserLive.Show, :show
    # live "/users/:id/show/edit", UserLive.Show, :edit
  end

  scope "/", GSGMSWeb do
    pipe_through [:browser]

    delete "/users/logout", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  # Other scopes may use custom stacks.
  # scope "/api", GSGMSWeb do
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
      live_dashboard "/dashboard", metrics: GSGMSWeb.Telemetry
    end
  end
end
