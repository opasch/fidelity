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

###  Rules

**List Rules**

```elixir

iex(27)> FidelityRuleEngine.Tables.Rules.list("1234")                                                                                                                       
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
iex(25)> FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{"merchant_id" => "1234", "name" => "test", "priority" => 1, "description" => "", "actions" => ["store"], "condition" => %{"ti_gt" => 4}})
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

**Lookup Rule**

```elixir
iex(5)> FidelityRuleEngine.Interfaces.RulesInterface.rule_lookup("1234","test_6")
[debug] QUERY OK source="rules_table" db=2.6ms queue=4.0ms idle=1308.0ms
SELECT r0."id", r0."name", r0."actions", r0."description", r0."priority", r0."merchant_id", r0."condition" FROM "rules_table" AS r0 WHERE (r0."name" = $1) ["1234_test_6"]
%{
  response: %{
    actions: ["store"],
    condition: %{"ti_gt" => 4},
    description: "",
    name: "1234_test_6",
    priority: 1
  }
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

### Rule Groups

**List Rule Groups**

```elixir
iex(8)> FidelityRuleEngine.Interfaces.RulesGroupInterface.rules_list("1234")                                                                                                                                                                        
%{
  response: [
    %{
      description: "This is a test rule group",
      name: "Group_test",
      priority: 1,
      rules: ["test", "test_2"],
      type: :unit_rule_group
    }
  ]
}
```



**Add Rules Groups**

```elixir
iex(25)> FidelityRuleEngine.Interfaces.RulesGroupInterface.add_rule(%{"merchant_id" => "1234","name" => "Group_test","description" => "This is a test rule group","priority" => 1,"rules" => ["test", "test_2"],"type" => "unit_rule_group"})
```

**Available types**

(UnitRuleGroup, ActivationRuleGroup, ConditionalRuleGroup)


**Wrong Payload validation**

```elixir
iex(22)> FidelityRuleEngine.Interfaces.RulesGroupInterface.add_rule(%{"name" => "Group_test","description" => "This is a test rule group","priority" => 1,"rules" => ["test", "test_2"],"type" => "unit_rule_group"})                        

22:29:22.181 [info]  Elixir.FidelityRuleEngine.Interfaces.RulesGroupInterface: Wrong Payload format received
%{
  response: "Oops, Wrong payload Format, It should be {\"name\" => name,\"priority\" => priority,\"description\" => description,\"type\" => type,\"rules\" => rules}"
}
```

**Delete Rule**

```elixir
iex(25)> FidelityRuleEngine.Interfaces.RulesGroupInterface.delete_rule("1234","test")
%{response: "Deleted"}
```




### Rules Set

**List Rules Set**

```elixir
iex(119)> FidelityRuleEngine.Interfaces.RulesSetInterfaces.rules_set_lookup("1234")
%{
  response: %{
    rules: [
      %{
        actions: ["store"],
        condition: %{"ti_gt" => 4},
        description: "",
        name: "test",
        priority: 1
      }
    ],
    rulesgroup: [
      %{
        description: "This is a test rule group",
        name: "Group_test",
        priority: 1,
        rules: ["test", "test_2"],
        type: :unit_rule_group
      }
    ],
    rulesset: ["test", "Group_test"]
  }
}

```

**Add Rules Set**

```elixir
iex(31)> FidelityRuleEngine.Interfaces.RulesSetInterfaces.add_rule(%{"merchant_id" => "1234","rules" => ["test","Group_test"]})
%{response: %{rules: ["test_1", "Group_test"]}}
```

**Delete Rule Set** 

This is also the same as remove the *merchant_id* from the database.

```elixir
iex(122)> FidelityRuleEngine.Interfaces.RulesSetInterfaces.delete_rule(%{"merchant_id" => "1234"})
%{response: :ok}
```

**TODO**
Clear all the rule tree with the *merchant_id** deletion 

### Fire Rule Engine 

As default Fidelity rule engine is consuming from RabbitMQ engine but it's possible to fire the engine directly.

Below example Fires the datamodel payload example [https://github.com/opasch/fidelity/wiki/Data-Model] with above rules loaded.

The result is `nil` for all the rules.
We then create a new rule `test_3` where prints "store" case the *total_items* is greater than 2 and add the rule to the rule set. 

Fire new event and now the rule engine will print the "store" (it can be produce a payload to rabbitMQ) and log which rule was triggered. 


```elixir
iex(43)> 
nil
iex(44)> FidelityRuleEngine.RuleEngines.Engine.main(payload_dec)
%{
  "cart_id" => "9roj8f70TUEU",
  "client_address" => "0xab96032f5a7Efe3F95622c5B9D98D50F96a91756",
  "items" => [
    %{
      "product_id" => "1",
      "product_name" => "product_1",
      "product_price" => "5.00"
    },
    %{
      "product_id" => "2",
      "product_name" => "product_2",
      "product_price" => "5.00"
    },
    %{
      "product_id" => "3",
      "product_name" => "product_3",
      "product_price" => "5.00"
    }
  ],
  "merchant_id" => "1234",
  "total_items" => 3,
  "total_price" => "15.00"
}
[nil, nil]
iex(45)> FidelityRuleEngine.Interfaces.RulesInterface.add_rule(%{"merchant_id" => "1234", "name" => "test_3", "priority" => 1, "description" => "", "actions" => ["store"], "condition" => %{"ti_gt" => 3}})
%{response: :ok}
iex(46)> FidelityRuleEngine.Interfaces.RulesSetInterfaces.add_rule(%{"merchant_id" => "1234","rules" => ["test_3"]})                                                                                        
%{response: :ok}


iex(48)> FidelityRuleEngine.RuleEngines.Engine.main(payload_dec)                                                                                                                                            
%{
  "cart_id" => "9roj8f70TUEU",
  "client_address" => "0xab96032f5a7Efe3F95622c5B9D98D50F96a91756",
  "items" => [
    %{
      "product_id" => "1",
      "product_name" => "product_1",
      "product_price" => "5.00"
    },
    %{
      "product_id" => "2",
      "product_name" => "product_2",
      "product_price" => "5.00"
    },
    %{
      "product_id" => "3",
      "product_name" => "product_3",
      "product_price" => "5.00"
    }
  ],
  "merchant_id" => "1234",
  "total_items" => 3,
  "total_price" => "15.00"
}
Store
[nil, nil, {"test_3", [:ok]}]
iex(49)> 

````




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

