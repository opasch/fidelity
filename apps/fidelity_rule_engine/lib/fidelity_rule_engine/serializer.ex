defmodule FidelityRuleEngine.Serializer do
  @moduledoc """
  Useful module to serialize payloads.
  """
  @derive {Jason.Encoder, only: [:name, :priority, :description]}

  defmodule Json do
    @moduledoc """
    Module that calls Jason serializer library 
    """
    def encode_message(message) do
      Jason.encode(message)
    end

    def encode_message(message, opts) do
      Jason.encode(message, opts)
    end

    def encode_message!(message, opts) do
      Jason.encode!(message, opts)
    end

    def decode_message(message) do
      Jason.decode(message)
    end

    def decode_message!(message) do
      Jason.decode!(message)
    end

    def decode_message(message, opts) do
      Jason.decode(message, opts)
    end

    def decode_message!(message, opts) do
      Jason.decode!(message, opts)
    end
  end

  defmodule Binary do
    @moduledoc """
    Module that serializes to erlang term
    """
    def encode_message(message) do
      {:ok, :erlang.term_to_binary(message)}
    end

    def decode_message(message) do
      {:ok, :erlang.binary_to_term(message)}
    end
  end
end
