defmodule PoolEngineWeb.UserController do
  use PoolEngineWeb, :controller

  alias PoolEngine.Accounts
  alias PoolEngine.Accounts.User

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
        jwt = Guardian.Plug.current_token(new_conn)

        new_conn
        |> put_status(:created)
        |> render(PoolEngine.SessionView, "show.json", user: user, jwt: jwt)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PoolEngine.ChangesetView, "error.json", changeset: changeset)
    end
  end

end
