defmodule FidelityRuleEngine.Schemas.AtomType do
  @behaviour Ecto.Type
  def type, do: :string

  def cast(value), do: {:ok, value}

  def load(value), do: {:ok, String.to_atom(value)}

  def dump(value) when is_atom(value), do: {:ok, Atom.to_string(value)}

  def dump(_), do: :error
end
