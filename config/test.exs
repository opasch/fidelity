import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# import configs from child apps
for config <- "../apps/*/config/test.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end
