# FidelityRuleEngine

**TODO: Add description**


## Rules interface

### Health

```elixir

iex(28)> FidelityRuleEngine.Interfaces.HealthInterface.health
%{
  connected_to: [],
  hostname: "alve",
  node: :nonode@nohost,
  ok: "2020-05-05T22:15:06.814514Z"
}
iex(29)>

```

### Set Rules

**List Rules**

```elixir

iex(27)> FidelityRuleEngine.Interfaces.RulesInterface.rules_list                                                                                                                        
%{
  response: [
    %{
      actions: ["store"],
      condition: %{"ti_gt" => 4},
      description: "",
      name: "test",
      priority: 1
    }
  ]
}
```

**Add Rules**

```elixir
iex(25)> FidelityRuleEngine.Interfaces.RulesInterface.add_rule("1234",%{"name" => "test", "priority" => 1, "description" => "", "actions" => ["store"], "condition" => %{"ti_gt" => 4}})
%{response: :ok}
```

**Wrong Payload validation**

```elixir
iex(32)> FidelityRuleEngine.Interfaces.RulesInterface.add_rule("1234",%{"name" => "test", "priority" => 1, "description" => "", "actions" => ["store"]})

23:20:27.180 [info]  Elixir.FidelityRuleEngine.Interfaces.RulesInterface: Wrong Payload format received
%{
  response: "Oops, Wrong payload Format, It should be {\"name\" => name,\"priority\" => priority,\"description\" => description,\"actions\" => actions,\"condition\" => condition}"
}
iex(33)> FidelityRuleEngine.Interfaces.RulesInterface.add_rule("1234")                                                                                  

23:20:43.205 [info]  Elixir.FidelityRuleEngine.Interfaces.RulesInterface: Wrong Payload format received
%{
  response: "Oops, Wrong payload Format, It should be {\"name\" => name,\"priority\" => priority,\"description\" => description,\"actions\" => actions,\"condition\" => condition}"
}
```

**Delete Rule**

```elixir
iex(38)> FidelityRuleEngine.Interfaces.RulesInterface.delete_rule("1234","test")
%{response: "Deleted"}
iex(39)> FidelityRuleEngine.Interfaces.RulesInterface.rules_list                
%{response: []}
iex(40)> 

```

**Available Actions**

`["store"]`

`["issue"]`

`[%{"alarm" => severity}]`

or a combination of any

`["store","issue",%{"alarm" => severity}]`

**Available Conditions**

`%{"ti_gt" => value}`- Total number of Items greater than `value`

`%{"ti_lt" => value}`- Total number of Items lower than `value`

`%{"ti_eq" => value}`- Total number of Items equal than `value`

`%{"tp_gt" => value}`- Total Price greater than `value`

`%{"tp_lt" => value}`- Total Price lower than `value`

`%{"tp_eq" => value}`- Total Price equal than `value`

`%{"client_address" => client_address}`- Client Address equal to `client_address` 


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fidelity_rule_engine` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fidelity_rule_engine, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fidelity_rule_engine](https://hexdocs.pm/fidelity_rule_engine).

