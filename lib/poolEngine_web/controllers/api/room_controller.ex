defmodule PoolEngineWeb.RoomController do
  use PoolEngineWeb, :controller

  alias PoolEngine.Messaging
  alias PoolEngine.Messaging.Room

  action_fallback PoolEngineWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated, handler: PoolEngineWeb.SessionController

  def index(conn, _params) do
    rooms = Messaging.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, %{"room" => room_params}) do
    with {:ok, %Room{} = room} <- Messaging.create_room(room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.room_path(conn, :show, room))
      |> render("show.json", room: room)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Messaging.get_room!(id)
    render(conn, "show.json", room: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Messaging.get_room!(id)

    with {:ok, %Room{} = room} <- Messaging.update_room(room, room_params) do
      render(conn, "show.json", room: room)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Messaging.get_room!(id)

    with {:ok, %Room{}} <- Messaging.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
