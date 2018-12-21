defmodule CookWeb.RecipeView do
  @moduledoc false

  use CookWeb, :view

  def render("show.json", %{recipes: recipes}) do
    %{
      recipes: render_many(recipes, __MODULE__, "recipe.json")
    }
  end

  def render("recipe.json", %{recipe: recipe}) do
    %{
      name: recipe.name,
      slug: recipe.slug,
      description: recipe.description,
      difficulty: recipe.difficulty,
      total_time: recipe.total_time,
      collections: recipe.collections,
      ingredients:
        render_many(recipe.ingredients, __MODULE__, "ingredient.json", as: :ingredient),
      method: recipe.method,
      likes: recipe.likes,
      views: recipe.views,
      created_by: recipe.user_id
    }
  end

  def render("ingredient.json", %{ingredient: ingredient}) do
    %{
      name: ingredient.name,
      quantity: ingredient.quantity,
      unit: ingredient.unit
    }
  end
end
