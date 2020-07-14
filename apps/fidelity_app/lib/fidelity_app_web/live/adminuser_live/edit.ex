defmodule FidelityAppWeb.AdminuserLive.Edit do
  use Phoenix.LiveView

  alias FidelityAppWeb.AdminuserLive
  alias FidelityAppWeb.AdminuserView
  alias FidelityAppWeb.Router.Helpers, as: Routes
  alias FidelityApp.Accounts
  alias FidelityApp.Accounts.User

  def mount(%{"id" => id} = params, _session, socket) do
    user = Accounts.get_user!(id)

    {:ok,
     assign(socket, %{
       user: user,
       changeset: FidelityApp.Accounts.User.changeset_role(user,%{})
     })}
  end

  def render(assigns), do: AdminuserView.render("edit.html", assigns)

  def handle_event("validate_role", %{"user" => params}, socket) do
    # IO.inspect params, label: "params"
    changeset =
      socket.assigns.user
      # |> IO.inspect()
      |> FidelityApp.Accounts.User.changeset_role(params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save_role", %{"user" => user_params}, socket) do

    # IO.inspect socket.assigns.user, label: "socket.assigns"
    # IO.inspect user_params, label: "user params save"

    case Accounts.set_role(socket.assigns.user, user_params) do
      {:ok, user} ->
        # IO.inspect(user, label: "new user ")
        {:reply, user,
         socket
         |> put_flash(:info, "User updated successfully.")
         |> redirect(to: Routes.live_path(socket, AdminuserLive.Show, user.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


  def handle_event("validate_password", %{"user" => params}, socket) do
    # IO.inspect params, label: "params"
    changeset =
      socket.assigns.user
      |> IO.inspect()
      |> FidelityApp.Accounts.User.password_changeset(params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end


  def handle_event("save_password", %{"user" => user_params}, socket) do

    # IO.inspect socket.assigns.user, label: "socket.assigns"
    # IO.inspect user_params, label: "user params save"

    case Accounts.update_user_password(socket.assigns.user, user_params) do
      {:ok, user} ->
        # IO.inspect(user, label: "new user ")
        {:reply, user,
         socket
         |> put_flash(:info, "User updated successfully.")
         |> redirect(to: Routes.live_path(socket, AdminuserLive.Show, user.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
