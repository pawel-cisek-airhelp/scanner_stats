defmodule ScannerStats.Router do
  use ScannerStats.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScannerStats do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", ScannerStats do
    pipe_through :api
    get "/test", StatsController, :test
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScannerStats do
  #   pipe_through :api
  # end
end
