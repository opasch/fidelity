defmodule GqlgatewayWeb.AssignUser do
  import Plug.Conn

  alias Gqlgateway.Accounts.User
  alias Gqlgateway.Repo

  def init(opts), do: opts

  def call(conn, params) do
    case Pow.Plug.current_user(conn) do
      %User{} = user ->
        assign(conn, :current_user, Repo.preload(user, params[:preload] || []))

      _ ->
        assign(conn, :current_user, nil)
    end
  end
end
