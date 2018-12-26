defmodule PoolEngineWeb.PageController do
  use PoolEngineWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
