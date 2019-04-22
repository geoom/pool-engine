defmodule PoolEngineWeb.Router do
  use PoolEngineWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", PoolEngineWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", PoolEngineWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
    post "/sessions/refresh", SessionController, :refresh

    resources "/users", UserController, only: [:create]
    get "/users/:id/rooms", UserController, :rooms

    resources "/rooms", RoomController, only: [:index, :create]
    post "/rooms/:id/join", RoomController, :join

  end
end
