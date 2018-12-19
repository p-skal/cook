defmodule CookWeb.API.SessionView do
  use CookWeb, :view

  def render("create.json", %{user: user, jwt: jwt}) do
    %{
      data: render_one(user, CookWeb.API.UserView, "user.json"),
      meta: %{token: jwt}
    }
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("error.json", %{error: error}) do
    %{errors: %{error: error}}
  end
end
