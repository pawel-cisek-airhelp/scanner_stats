defmodule ScannerStats.PageController do
  use ScannerStats.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
