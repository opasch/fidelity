defmodule GqlgatewayWeb.UserLive.Index do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Gqlgateway.Accounts
  alias GqlgatewayWeb.UserView

  def mount(params, _session, socket) do
    IO.inspect(params)
    {:ok, fetch(socket)}
  end

  def render(assigns) do
    #  IO.inspect assigns
  # UserView.render("index.html", assigns)
  ~L"""
  <h1>Listing Users</h1>

<table>
  <thead>
    <tr>
      <th>Email</th>
      <th>Wallet</th>
      <th>Role</th>

      <th></th>
    </tr>
  </thead>
  <tbody>
<%= for user <- @users do %>
    <tr>
      <td><%= user.email %></td>
      <td><%= user.wallet %></td>
      <td><%= user.role %></td>

      <td>
        <%= link "Show", to: Routes.live_path(@socket, UserLive.Show, user) %>
        <%= link "Edit", to: Routes.live_path(@socket, UserLive.Edit, user) %>
        <%= link "Delete", to: '#',
            phx_click: "delete_user",
            phx_value: user.id,
            data: [confirm: "Are you sure?"] %>
      </td>
    </tr>
<% end %>
  </tbody>
</table>

<span><%= link "New User", to: Routes.live_path(@socket, UserLive.New) %></span>

  """

  end

  defp fetch(socket) do
    assign(socket, users: Accounts.list_users())
    |> IO.inspect
  end

  def handle_event("delete_user", id, socket) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)
    {:noreply, fetch(socket)}
  end
end
