defmodule FidelityAppWeb.PageController do
  use FidelityAppWeb, :controller

  #   plug FidelityAppWeb.AssignUser, preload: :conversations

  def index(conn, opts \\ []) do
    IO.inspect(conn)
    render(conn, "index.html")
  end
end
