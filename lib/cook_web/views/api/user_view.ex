defmodule CookWeb.API.UserView do
  use CookWeb, :view

  def render("user.json", %{user: user}) do
    %{
      name: user.name,
      handle: user.handle,
      email: user.email
    }
  end
end
