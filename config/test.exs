import Config

# import configs from child apps
for config <- "../apps/*/config/test.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end
