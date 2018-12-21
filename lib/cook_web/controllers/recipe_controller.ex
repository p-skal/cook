defmodule CookWeb.RecipeController do
  use CookWeb, :controller

  alias Cook.Recipes
  alias Cook.Recipes.Recipe

  def index(conn, _params) do
    recipes = Recipes.list_recipes()

    conn
    |> render("show.json", recipes: recipes)
  end

  def show(conn, %{"slug" => slug}) do
    case Recipes.get_by_slug(slug) do
      recipe = %Recipe{} ->
        conn
        |> put_status(:ok)
        |> render("recipe.json", recipe: recipe)

      nil ->
        conn
        |> put_status(:not_found)
        |> render(CookWeb.ErrorView, "404.json")
    end
  end
end
