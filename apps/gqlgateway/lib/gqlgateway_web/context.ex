defmodule GqlgatewayWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Gqlgateway.{Accounts}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- authorize(token) do
      %{current_user_claims: claims}
    else
      nil ->
        {:error, "Unauthorized"}

      _ ->
        %{}
    end
  end

  defp authorize(token) do
    case Accounts.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, reason} ->
        {:error, reason}

      nil ->
        {:error, "Unauthorized"}
    end
  end
end
