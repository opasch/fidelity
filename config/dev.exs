import Config

# import configs from child apps
for config <- "../apps/*/config/dev.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end
