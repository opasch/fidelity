defmodule GqlgatewayWeb.Router do
  use GqlgatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug GqlgatewayWeb.Context
  end

  pipeline :basic_auth do
    plug BasicAuth, use_config: {:gqlgateway, :admin_credentials}
  end

  scope "/gql" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: GqlgatewayWeb.Schema

    forward "/", Absinthe.Plug,
      schema: GqlgatewayWeb.Schema

  end

  # Enables LiveDashboard
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery, :basic_auth]
    live_dashboard "/dashboard", metrics: GqlgatewayWeb.Telemetry
  end
end
