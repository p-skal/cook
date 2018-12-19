defmodule CookWeb.UserController do
  use CookWeb, :controller

  alias Cook.Accounts
  alias Cook.Accounts.User
  alias Cook.Auth.Guardian

  action_fallback(CookWeb.FallbackController)

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
