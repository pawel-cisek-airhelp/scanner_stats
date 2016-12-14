defmodule ScannerStats.WebappGateway do
  @timeout 20_000
  def get_lead(lead_id) do
    url2 = "http://localhost:7000/api/scanner_leads/"
    url_with_lead = url2 <> to_string(lead_id)
    HTTPotion.get url_with_lead,  [timeout: @timeout]
  end

  def get_lead_ids_for_user(user_id) do
    url = "http://localhost:7000/api/scanner_leads/ids/"
    url_with_user = url <> to_string(user_id)
    HTTPotion.get url_with_user,  [timeout: @timeout]
  end
end
