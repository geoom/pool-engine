defmodule PoolEngineWeb.UserController do
  use PoolEngineWeb, :controller

  alias PoolEngine.Accounts
  alias PoolEngine.Accounts.User

  plug Guardian.Plug.EnsureAuthenticated, [handler: PoolEngineWeb.SessionController] when action in [:rooms]

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt = Guardian.Plug.current_token(new_conn)

        new_conn
        |> put_status(:created)
        |> render(PoolEngineWeb.SessionView, "show.json", user: user, jwt: jwt)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PoolEngineWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def rooms(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    rooms = Repo.all(assoc(current_user, :rooms)

    render(conn, PoolEngineWeb.RoomView, "index.json", %{rooms: rooms})
  end
  
end
