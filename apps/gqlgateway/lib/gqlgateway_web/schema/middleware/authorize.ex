defmodule GqlgatewayWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    with %{current_user_claims: _} <- resolution.context do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, %{message: "Unauthorized"}})
    end
  end
end