defmodule PoolEngineWeb.ApplicationController do
  use PoolEngineWeb, :controller

  def not_found(conn, _params) do
    conn
    |> put_status(:not_found)
    |> render(PoolEngineWeb.ApplicationView, "not_found.json")
  end
end
