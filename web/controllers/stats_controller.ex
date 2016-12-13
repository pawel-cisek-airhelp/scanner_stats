defmodule ScannerStats.StatsController do
  use ScannerStats.Web, :controller
  alias ScannerStats.WebappGateway

  def test(conn, %{"user_id" => user_id}) do
    get_leads(user_id)

    json conn, %{works: user_id}
  end

  defp get_leads(user_id) do
    lead_ids = Poison.Parser.parse!(WebappGateway.get_lead_ids_for_user(user_id).body)

    # Enum.map(lead_ids["lead_ids"], fn(lead_id) -> get_lead(lead_id) end)
    #  Enum.map(lead_ids["lead_ids"], fn(lead_id) -> Task.await(Task.async(fn -> get_lead(lead_id) end)) end)
     Enum.map(lead_ids["lead_ids"], fn(lead_id) -> Task.async(fn -> get_lead(lead_id) end) end)
     |> Enum.map(&Task.await(&1, 20000))
    #  Enum.map(lead_ids["lead_ids"], fn(lead_id) -> get_lead(lead_id) end)
  end

  defp get_lead(lead_id) do
    WebappGateway.get_lead(lead_id)
  end
end
