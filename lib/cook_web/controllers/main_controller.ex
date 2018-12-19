defmodule CookWeb.MainController do
  @moduledoc false

  use CookWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:api_token, "12345")
    |> assign(:module, "main")
    |> render("index.html")
  end
end
