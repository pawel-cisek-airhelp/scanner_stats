defmodule ScannerStats.Lead do
  @derive [Poison.Encoder]
  defstruct [
    :id,
    :ec261_candidate,
    :journey_departure_time,
    :compensation_in_currencies,
    :duration,
    :itinerary]
end
