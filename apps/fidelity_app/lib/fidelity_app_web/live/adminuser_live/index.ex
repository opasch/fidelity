defmodule FidelityAppWeb.AdminuserLive.Index do
  use FidelityAppWeb, :live_view

  alias FidelityApp.Accounts
  alias FidelityAppWeb.AdminuserView
  # alias FidelityAppWeb.Accounts.User
  # alias FidelityAppWeb.AdminUserView

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    Accounts.subscribe()
    users = Accounts.list_users()
    # |> IO.inspect(label: "List of users")
    # {:ok, assign(socket, :users, users)}
    {:ok, fetch(socket)}
    # {:ok, socket}
  end

  def render(assigns) do
    AdminuserView.render("index.html", assigns)
  end

  defp fetch(socket) do
    assign(socket, :users, Accounts.list_users())
  end

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


  def handle_event("delete_user", id, socket) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)
    {:noreply, fetch(socket) }
  end

end
