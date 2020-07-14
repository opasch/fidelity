defmodule FidelityAppWeb.Router do
  use FidelityAppWeb, :router

  import FidelityAppWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FidelityAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug FidelityAppWeb.Plugs.EnsureRolePlug, :admin
  end

  pipeline :customer do
    plug FidelityAppWeb.Plugs.EnsureRolePlug, [:customer, :admin]
  end

  pipeline :merchant do
    plug FidelityAppWeb.Plugs.EnsureRolePlug, [:merchant, :admin]
  end


  scope "/", FidelityAppWeb do
    pipe_through :browser

    get "/", PageController, :index
    # live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", FidelityAppWeb do
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

    scope "/admin", FidelityAppWeb  do
      pipe_through [:browser, :require_authenticated_user, :admin]

      # live "/", AdminLive
      # live "/users", AdminLive

      live_dashboard "/dashboard", metrics: FidelityAppWeb.Telemetry


    end
  end

  ## Authentication routes

  scope "/", FidelityAppWeb do
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

  scope "/", FidelityAppWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

  end


  scope "/", FidelityAppWeb do
    pipe_through [:browser, :require_authenticated_user, :customer]

    live "/customer", CustomerLive

  end

  scope "/", FidelityAppWeb do
    pipe_through [:browser, :require_authenticated_user, :merchant]

    live "/merchant", CustomerLive

  end


  scope "/", FidelityAppWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]

    live "/admin", AdminLive
    live "/admin/users", AdminuserLive.Index
    live "/admin/users/:id", AdminuserLive.Show
    live "/admin/users/:id/edit", AdminuserLive.Edit
  end

  scope "/", FidelityAppWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

end
