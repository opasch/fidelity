defmodule GqlgatewayWeb.Schema do
  use Absinthe.Schema

  import AbsintheErrorPayload.Payload
  import_types GqlgatewayWeb.Schema.Types

  alias GqlgatewayWeb.Resolver
  alias GqlgatewayWeb.Schema.Middleware

  query do
    field :me, type: :user do

      middleware Middleware.Authorize
      resolve &Resolver.Accounts.me/3
    end
  end

  mutation do
    field :create_customer, type: :user_payload do
      arg :params, :create_user_params

      resolve &Resolver.Accounts.create_customer/3
      middleware &build_payload/2
    end

    field :create_merchant, type: :user_payload do
      arg :params, :create_user_params

      resolve &Resolver.Accounts.create_merchant/3
      middleware &build_payload/2
    end

    field :login, type: :auth_token_payload do
      arg :params, :login_params

      resolve &Resolver.Accounts.login/3
      middleware &build_payload/2
    end

    field :logout, type: :auth_token_payload do
      middleware Middleware.Authorize
      
      resolve &Resolver.Accounts.logout/3
      middleware &build_payload/2
    end
  end

end