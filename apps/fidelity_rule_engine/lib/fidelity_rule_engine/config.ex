defmodule FidelityRuleEngine.Config do
  @moduledoc """
  Convenience Getters for pulling config.exs values

  A config.exs may look like
  ```
  # test env
  config :fidelity_rule_engine,
    instance: "https://192.168.1.64",
    username: "guest",
    password: "guest"
  ```
  """

  def instance do
    Application.get_env(:fidelity_rule_engine, :instance) || System.get_env("FIDELITY_API_HOST") ||
      "https://192.168.1.64"
  end

  @doc """
  Function returning the Serializer

  Example: 
  iex> FidelityRuleEngine.Config.serializer()
  "Serializer.Json"
  """
  def serializer do
    # Env.fetch!(:fidelity_rule_engine, :serializer) || Serializer.Json
    Application.get_env(:fidelity_rule_engine, :serializer) || Serializer.Json
  end

  # def api_port do
  #   # Env.fetch!(:fidelity_rule_engine, :port) || "80"
  #   # Application.get_env(:fidelity_rule_engine, :port) |> String.to_integer() || 80
  #   # System.get_env("API_PORT") |> String.to_integer() || 80
  #   Application.get_env(:fidelity_rule_engine, :api_port) ||
  #     String.to_integer(System.get_env("API_PORT") || "8080")
  # end

  def fidelity_broker_uri do
    "amqp://" <>
      Application.get_env(:fidelity_rule_engine, :fidelity_broker_username) <>
      ":" <>
      Application.get_env(:fidelity_rule_engine, :fidelity_broker_password) <>
      "@" <>
      Application.get_env(:fidelity_rule_engine, :fidelity_broker_host) <>
      ":" <>
      Application.get_env(:fidelity_rule_engine, :fidelity_broker_host_port) <>
      Application.get_env(:fidelity_rule_engine, :fidelity_broker_vhost)
  end

  def fidelity_broker_connector_queue do
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_connector_queue)
  end

  def fidelity_broker_normalized_queue do
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_normalized_queue) ||
      System.get_env("FIDELITY_NORMALIZED_QUEUE") || "fidelity_normalized"
  end

  def fidelity_broker_consumer_queue do
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_consumer_queue) ||
      System.get_env("FIDELITY_CONSUMER_QUEUE") || "fidelity_consumer"
  end

  def fidelity_broker_username do
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_username)
  end

  def fidelity_broker_password do
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_password)
  end

  def fidelity_broker_host do
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_host)
  end

  def fidelity_broker_host_port do
    # String.to_integer(Application.get_env(:fidelity_rule_engine, :fidelity_broker_host_port))
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_host_port)
  end

  def fidelity_broker_vhost do
    Application.get_env(:fidelity_rule_engine, :fidelity_broker_vhost)
  end
end
