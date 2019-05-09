defmodule PoolEngineWeb.RoomController do
  use PoolEngineWeb, :controller

  alias PoolEngine.Messaging
  alias PoolEngine.Messaging.Room
  alias PoolEngine.Repo

  action_fallback PoolEngineWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated, handler: PoolEngineWeb.SessionController

  def index(conn, _params) do
    rooms = Messaging.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset = Room.changeset(%Room{}, params)

    case Repo.insert(changeset) do
      {:ok, room} ->
        assoc_changeset = PoolEngine.UserRoom.changeset(
          %PoolEngine.UserRoom{},
          %{user_id: current_user.id, room_id: room.id}
        )
        Repo.insert(assoc_changeset)

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.room_path(conn, :show, room))
        |> render("show.json", room: room)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PoolEngineWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    room = Repo.get(Room, room_id)

    changeset = PoolEngine.UserRoom.changeset(
      %PoolEngine.UserRoom{},
      %{room_id: room.id, user_id: current_user.id}
    )

    case Repo.insert(changeset) do
      {:ok, _user_room} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{room: room})
      {:error,  changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PoolEngineWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

end
