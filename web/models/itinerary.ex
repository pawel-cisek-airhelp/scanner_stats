defmodule ScannerStats.Itinerary do
  @derive [Poison.Encoder]
  defstruct [:id, :flights]
end
