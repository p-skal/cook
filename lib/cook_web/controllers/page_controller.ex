defmodule CookWeb.PageController do
  use CookWeb, :controller

  plug :put_layout, "page.html"

  def index(conn, _params) do
    user_count = 2

    conn
    |> assign(:module, "home")
    |> assign(:user_count, user_count)
    |> render("index.html")
  end

  def manifesto(conn, _params) do
    render(conn, "manifesto.html")
  end
end
