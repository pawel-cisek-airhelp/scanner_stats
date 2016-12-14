defmodule ScannerStats.Flight do
  @derive [Poison.Encoder]
  defstruct [:airline, :arrival_airport, :departure_airport, :distance_km, :departure_year]
end
