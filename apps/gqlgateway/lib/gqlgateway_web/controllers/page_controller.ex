defmodule GqlgatewayWeb.PageController do
  use GqlgatewayWeb, :controller

  #   plug GqlgatewayWeb.AssignUser, preload: :conversations

  def index(conn, opts \\ []) do
    IO.inspect(conn)
    render(conn, "index.html")
  end
end
