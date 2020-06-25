defmodule GqlgatewayWeb.Admin.UserController do
  use GqlgatewayWeb, :controller
  alias Gqlgateway.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end
