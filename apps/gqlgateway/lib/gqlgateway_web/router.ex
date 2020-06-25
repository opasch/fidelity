defmodule GqlgatewayWeb.Router do
  use GqlgatewayWeb, :router
  use Pow.Phoenix.Router

  # alias GqlgatewayWeb.Admin

  pipeline :admin do
    plug GqlgatewayWeb.EnsureRolePlug, :admin
  end

  pipeline :customer do
    plug GqlgatewayWeb.EnsureRolePlug, :customer
  end

  pipeline :merchant do
    plug GqlgatewayWeb.EnsureRolePlug, :merchant
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    # plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug GqlgatewayWeb.Context
  end

  # pipeline :basic_auth do
  #   plug BasicAuth, use_config: {:gqlgateway, :admin_credentials}
  # end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser
    pow_routes()
  end

  scope "/", GqlgatewayWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/gql" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: GqlgatewayWeb.Schema

    forward "/", Absinthe.Plug, schema: GqlgatewayWeb.Schema
  end

  # Enables LiveDashboard
  import Phoenix.LiveDashboard.Router

  scope "/admin", GqlgatewayWeb do
    pipe_through [:browser, :protected, :admin]

    live "/", UserLive.Index
    live "/users", UserLive.Index

    # resources "/users", Admin.UserController, only: [:index, :show]
    live_dashboard "/dashboard", metrics: GqlgatewayWeb.Telemetry
  end

  scope "/customer", GqlgatewayWeb do
    pipe_through [:browser, :protected, :customer]

    live_dashboard "/", metrics: GqlgatewayWeb.Telemetry
  end

  scope "/merchant", GqlgatewayWeb do
    pipe_through [:browser, :protected, :merchant]

    live_dashboard "/", metrics: GqlgatewayWeb.Telemetry
  end

  # scope "/" do
  #   pipe_through [:fetch_session, :protect_from_forgery, :basic_auth]
  #   live_dashboard "/dashboard", metrics: GqlgatewayWeb.Telemetry
  # end
end
