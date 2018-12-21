defmodule CookWeb.UserController do
  use CookWeb, :controller

  alias Cook.Accounts
  alias Cook.Accounts.User
  alias Cook.Auth.Guardian

  action_fallback(CookWeb.FallbackController)

  def index(conn, _params) do
    users = Accounts.list_users()

    conn
    |> put_status(:ok)
    |> render("show.json", users: users)
  end

  def show(conn, %{"handle" => handle}) do
    case Accounts.get_by_handle(handle) do
      user = %User{} ->
        conn
        |> put_status(:ok)
        |> render("user.json", user: user)

      nil ->
        conn
        |> put_status(:not_found)
        |> render(CookWeb.ErrorView, "404.json")
    end
  end

  def create(conn, params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      new_conn = Guardian.Plug.sign_in(conn, user)
      jwt = Guardian.Plug.current_token(new_conn)

      new_conn
      |> put_status(:created)
      |> render(CookWeb.API.SessionView, "create.json", user: user, jwt: jwt)
    end
  end
end
