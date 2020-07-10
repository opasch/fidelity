defmodule FidelityAppWeb.AdminuserLive do
  use FidelityAppWeb, :live_view

  alias FidelityApp.Accounts
  # alias FidelityAppWeb.Accounts.User
  # alias FidelityAppWeb.AdminUserView

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    Accounts.subscribe()
    users = Accounts.list_users()
    # |> IO.inspect(label: "List of users")
    {:ok, assign(socket, :users, users)}
    # {:ok, fetch(socket)}
    # {:ok, socket}
  end


  # def render(assigns) do
  #   ~L""
  # end

  # @impl true
  # def render(assigns) do
  # ~L"""
  # <h1>Listing Users</h1>

  # <table>
  #   <thead>
  #     <tr>
  #       <th>role</th>
  #       <th>Email</th>
  #       <!--th></th-->
  #     </tr>
  #   </thead>
  #   <tbody>
  #   <%= for user <- @users do %>
  #       <tr>
  #         <td><%= user.email %></td>
  #         <td><%= user.role %></td>
  #         <!--td>
  #           <%= link "Show", to: Routes.live_path(@socket, AdminUserLive.Show, user) %>
  #           <%= link "Edit", to: Routes.live_path(@socket, AdminUserLive.Edit, user) %>
  #           <%= link "Delete", to: '#',
  #               phx_click: "delete_user",
  #               phx_value: user.id,
  #               data: [confirm: "Are you sure?"] %>
  #         </td-->
  #       </tr>
  #   <% end %>
  #   </tbody>
  # </table>

  # """


  # end

  # defp fetch(socket) do
  #   assign(socket, :users, Accounts.list_users())
  # end

  # @impl true
  # def handle_event("delete_user", id, socket) do
  #   user = Accounts.get_user!(id)
  #   {:ok, _user} = Accounts.delete_user(user)
  #   {:noreply, fetch(socket) }
  # end

  def handle_info({Accounts, [:user | _], _}, socket) do
    users = Accounts.list_users()
    {:noreply, assign(socket, users: users)}
  end


end
