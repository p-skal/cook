defmodule CookWeb.SessionController do
  use CookWeb, :controller

  alias Cook.Accounts
  alias Cook.Auth.Guardian
  alias CookWeb.Router.Helpers

  def new(conn, _params) do
    conn
    |> assign(:page_title, "Sign In")
    |> render("new.html")
  end

  def destroy(conn, _) do
    conn
    |> redirect_after_sign_out()
  end

  defp redirect_after_sign_out(conn) do
    conn
    |> put_flash(:info, "You're signed out!")
    |> redirect(to: "/sign-in")
  end

  defp redirect_if_signed_in(conn, _opts) do
    if conn.assigns.current_user do
      conn
      |> redirect(to: Helpers.main_path(conn, :index, ["browse"]))
      |> halt()
    else
      conn
    end
  end

  def create(conn, params) do
    case authenticate(params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)

        new_conn
        |> put_status(:created)
        |> render("show.json", user: user, jwt: jwt)

      :error ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", error: "User or email invalid")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:no_content)
    |> render("delete.json")
  end

  def refresh(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    jwt = Guardian.Plug.current_token(conn)

    case Guardian.refresh(jwt, ttl: {30, :days}) do
      {:ok, _, {new_jwt, _new_claims}} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user, jwt: new_jwt)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", error: "Not Authenticated")
    end
  end

  defp authenticate(%{"email" => email, "password" => password}) do
    Accounts.authenticate(email, password)
  end

  defp authenticate(_), do: :error
end
