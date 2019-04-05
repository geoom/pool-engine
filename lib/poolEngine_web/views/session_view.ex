defmodule PoolEngineWeb.SessionView do
  use PoolEngineWeb, :view

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      data: render_one(user, PoolEngineWeb.UserView, "user.json"),
      meta: %{token: jwt}
    }
  end

  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end
