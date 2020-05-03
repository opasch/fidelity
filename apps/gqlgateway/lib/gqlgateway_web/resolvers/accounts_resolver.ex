defmodule GqlgatewayWeb.Resolver.Accounts do
  alias Gqlgateway.Accounts

  def me(_parent, _params, %{context: %{current_user_claims: claims}}) do
    {:ok, user} = Accounts.Guardian.resource_from_claims(claims)
    {:ok, user}
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

  def login_customer(_parent, %{params: user}, _resolution) do
    login(user, &Accounts.is_customer?/1)
  end

  def login_merchant(_parent, %{params: user}, _resolution) do
    login(user, &Accounts.is_merchant?/1)
  end

  def logout(_parent, _params, %{context: %{current_user_claims: claims}}) do
    with %{jwt: jwt} <- Guardian.DB.Token.find_by_claims(claims),
         {:ok, _}    <- Accounts.Guardian.revoke(jwt) do
      {:ok, %{token: jwt}}
    else
      _ ->
        {:error, %{message: "Unable to authenticate"}}
    end
  end

  defp login(user, has_role?) do
    with {:ok, u} <- Accounts.authenticate_user(user.username, user.password),
         true <- has_role?.(u),
         {:ok, jwt, _claims} <- Accounts.Guardian.encode_and_sign(u) do
    {:ok, %{token: jwt}}
    else
      _ ->
        {:error, %{message: "Unable to authenticate"}}
    end
  end

  defp create_user(user) do
    case Accounts.create_user(user) do
      {:error, changeset} ->
        {:ok, changeset}
      {:ok, user} ->
        {:ok, user}
    end
  end
end