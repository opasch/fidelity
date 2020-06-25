defmodule GqlgatewayWeb.UserLive.Show do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias GqlgatewayWeb.UserView
  alias Gqlgateway.Accounts
  alias Phoenix.LiveView.Socket

  def render(assigns), do: UserView.render("show.html", assigns)

  def mount(%{path_params: %{"id" => id}}, socket) do
    {:ok, fetch(assign(socket, id: id))}
  end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    assign(socket, user: Accounts.get_user!(id))
  end
end
