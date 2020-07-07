defmodule GqlgatewayWeb.MerchantLive do
  use GqlgatewayWeb, :live_view

  alias FidelityRuleEngine.Interfaces.RulesInterface
  alias Gqlgateway.Accounts

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    socket =
      assign(socket,
      rules: RulesInterface.rules_list(user_id)
      )

    {:ok, socket}
  end


  def render(assigns) do
    ~L"""
    <h1> Rules </h1>



    """
  end


end
