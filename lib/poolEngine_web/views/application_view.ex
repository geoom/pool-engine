defmodule PoolEngineWeb.ApplicationView do
  use PoolEngineWeb, :view

  def render("not_found.json", _) do
    %{error: "Not found"}
  end
end
