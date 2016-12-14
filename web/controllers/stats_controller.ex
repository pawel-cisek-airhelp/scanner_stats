defmodule ScannerStats.StatsController do
  use ScannerStats.Web, :controller
  alias ScannerStats.WebappGateway
  alias ScannerStats.Lead
  alias ScannerStats.Itinerary
  alias ScannerStats.Flight
  alias ScannerStats.Airport
  alias ScannerStats.Airline

  def test(conn, %{"user_id" => user_id}) do
    get_leads(user_id)

    json conn, %{works: user_id}
  end

  defp get_leads(user_id) do
    response = WebappGateway.get_lead_ids_for_user(user_id)
    if HTTPotion.Response.success?(response) do
      lead_ids = Poison.Parser.parse!(response.body)

    # Enum.map(lead_ids["lead_ids"], fn(lead_id) -> get_lead(lead_id) end)
    #  Enum.map(lead_ids["lead_ids"], fn(lead_id) -> Task.await(Task.async(fn -> get_lead(lead_id) end)) end)
     leads =
     Enum.map(lead_ids["lead_ids"], fn(lead_id) -> Task.async(fn -> get_lead(lead_id) end) end)
     |> Enum.map(&Task.await(&1, 20000))
     |> Enum.filter(fn(lead) -> lead != nil end)



     total_duration_min = Enum.map(leads, fn(lead) -> lead["lead"].duration end)
     |> Enum.sum

     IO.puts "!!!!!! TOTAL DURATION: " <> to_string(total_duration_min)
    #  IO.puts total_duration_min



     # counting visited airports etc

     country_names =
     leads
     |> Enum.flat_map(&(&1["lead"].itinerary.flights))
     |> Enum.flat_map(&([&1.arrival_airport.country, &1.departure_airport.country]))
     |> Enum.uniq

     IO.puts "COUNTRY NAMEEEESSSS: "
     IO.inspect country_names

     airline_identifiers =
       leads
       |> Enum.flat_map(&(&1["lead"].itinerary.flights))
       |> Enum.map(&(&1.airline.id))

     IO.puts "AIRLINE IDENTIFIERS: " <> to_string(airline_identifiers)
    #  IO.inspect airline_identifiers

    #  airline_acc = %{}
     airline_map =
       Enum.reduce(airline_identifiers, %{}, fn(airline_id, airline_acc) ->
         if Map.has_key?(airline_acc, airline_id) do
           Map.put(airline_acc, airline_id, Map.get(airline_acc, airline_id) + 1)
         else
           Map.put(airline_acc, airline_id, 1)
         end
       end)

       IO.puts "AIRLINE MAP: "
       IO.inspect airline_map


       total_distance_km =
       leads
       |> Enum.flat_map(&(&1["lead"].itinerary.flights))
       |> Enum.map(&(&1.distance_km))
       |> Enum.sum

       IO.puts "TOTAL DISTANCE : " <> to_string(total_distance_km)
      #  IO.puts total_distance_km

      #  distance_km_by_year=
      #  leads
      #  |> Enum.flat_map(&(&1["lead"].itinerary.flights))
      #  |> Enum.map(&(&1.distance_km))

      #  distance_km_by_year_acc = %{}
       distance_km_by_year =
        #  Enum.map_reduce(leads, %{}, fn(lead, dis_km_acc) ->
        #    lead["lead"].
        #  end)
        leads
        |> Enum.flat_map(&(&1["lead"].itinerary.flights))
        |> Enum.map(&([&1.departure_year, &1.distance_km]))
        |> Enum.group_by(&List.first/1, &Enum.at(&1, 1))
        |> Enum.map(fn {k, v} -> {k, Enum.sum(v)} end)
        |> Map.new

        IO.puts "DISTANCE KM YEAR: "
        IO.inspect distance_km_by_year


     eligible_leads = Enum.filter(leads, fn(lead) -> lead["lead"].ec261_candidate != nil end)
    #  IO.puts "LEADSSSSS"
    #  IO.inspect leads

    #  IO.puts "eligible LEADSSSSS"
    #  IO.inspect eligible_leads
   else
     IO.puts "TIMING OUT"
   end
    #  Enum.map(lead_ids["lead_ids"], fn(lead_id) -> get_lead(lead_id) end)
  end


  defp get_lead(lead_id) do
    response = WebappGateway.get_lead(lead_id)
    if HTTPotion.Response.success?(response) do
      parsed_response = parse_response(response)
      IO.inspect parsed_response
      Poison.decode!(response.body, as:
        %{"lead" => %Lead{
          itinerary: %Itinerary{
            flights: [%Flight{
              airline: %Airline{},
              arrival_airport: %Airport{},
              departure_airport: %Airport{}
              }]
            }
          }
        }
      )
    else
      IO.puts "TIMED OUT LEAD ID " <> to_string(lead_id)
      nil
    end
  end

  defp parse_response(response) do
    # IO.puts response.body
    Poison.Parser.parse!(response.body)
  end

end
