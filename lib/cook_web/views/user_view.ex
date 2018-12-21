defmodule CookWeb.UserView do
  use CookWeb, :view

  def render("show.json", %{users: users}) do
    %{
      users: render_many(users, __MODULE__, "user.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      name: user.name,
      handle: user.handle,
      date_joined: NaiveDateTime.to_date(user.created_at)
    }
  end
end
