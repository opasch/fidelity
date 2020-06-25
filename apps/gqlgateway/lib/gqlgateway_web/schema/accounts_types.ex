defmodule GqlgatewayWeb.Schema.Types do
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload
  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  object :user do
    field :id, :id
    field :email, :string
    field :username, :string
  end

  payload_object(:user_payload, :user)

  input_object :create_user_params do
    field :email, non_null(:string)
    field :username, non_null(:string)
    field :password, non_null(:string)
  end

  object :auth_token do
    field :token, :string
  end

  payload_object(:auth_token_payload, :auth_token)

  input_object :login_params do
    field :username, non_null(:string)
    field :password, non_null(:string)
  end

  input_object :logout_params do
    field :token, non_null(:string)
  end
end
