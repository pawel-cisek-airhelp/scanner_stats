defmodule ScannerStats.Airport do
  @derive [Poison.Encoder]
  defstruct [:iata, :country, :name]
end
