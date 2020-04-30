defmodule GqlgatewayWeb.Resolver.Accounts do
  alias Gqlgateway.Accounts

  def me(_parent, _params, resolution) do
    {:ok, resolution.context.current_user}
  end

  def create_customer(_parent, %{params: user}, _resolution) do
    user
    |> Map.put(:roles, ["customer"])
    |> create_user()
  end

  def create_merchant(_parent, %{params: user}, _resolution) do
    user
    |> Map.put(:roles, ["merchant"])
    |> create_user()
  end

  def login(_parent, %{params: user}, _resolution) do
    with {:ok, u} <- Accounts.authenticate_user(user.username, user.password), 
         {:ok, jwt, _claims} <- Accounts.Guardian.encode_and_sign(u) do
      {:ok, %{token: jwt}}
    else
      _ ->
        {:error, "unable to authenticate"}
    end
  end

  def logout(_parent, _params, %{context: context}) do
    with {:ok, _} <- Accounts.Guardian.revoke(context.token) do
      {:ok, context.token}
    end
  end

  defp create_user(user) do
    case Accounts.create_user(user) do
      {:error, changeset} ->
        {:error, changeset}
      {:ok, user} ->
        {:ok, user}
    end
  end
end