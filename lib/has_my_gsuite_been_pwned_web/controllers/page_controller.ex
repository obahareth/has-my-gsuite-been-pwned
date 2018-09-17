defmodule HasMyGsuiteBeenPwnedWeb.PageController do
  use HasMyGsuiteBeenPwnedWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
