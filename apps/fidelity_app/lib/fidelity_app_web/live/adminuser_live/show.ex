defmodule FidelityAppWeb.AdminuserLive.Show do
  use FidelityAppWeb, :live_view
  # use Phoenix.HTML

  alias FidelityAppWeb.AdminuserView
  alias FidelityApp.Accounts

  def render(assigns) do
    AdminuserView.render("show.html", assigns)
  end


  # @impl Phoenix.LiveView
  def mount(%{"id" => id} = params, session, socket) do

    user = Accounts.get_user!(id)
    {:ok, assign(socket, user: user)}

  end

end
