defmodule Cook.RecipesTest do
  use Cook.DataCase

  alias Cook.Recipes

  describe "recipes" do
    alias Cook.Recipes.Recipe

    @valid_attrs %{
      collections: [],
      recipe_link: "some-recipe",
      description: "some description",
      difficulty: "some difficulty",
      images: [],
      ingredients: [],
      likes: 42,
      method: [],
      name: "some name",
      source: "some source",
      total_time: "some total_time",
      views: 42
    }
    @update_attrs %{
      collections: [],
      recipe_link: "some-updated-recipe",
      description: "some updated description",
      difficulty: "some updated difficulty",
      images: [],
      ingredients: [],
      likes: 43,
      method: [],
      name: "some updated name",
      source: "some updated source",
      total_time: "some updated total_time",
      views: 43
    }
    @invalid_attrs %{
      collections: nil,
      description: nil,
      difficulty: nil,
      images: nil,
      ingredients: nil,
      likes: nil,
      method: nil,
      name: nil,
      source: nil,
      total_time: nil,
      views: nil
    }

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Recipes.list_recipes() == [recipe]
    end

    test "get_recipe/1 returns the recipe with given recipe_link" do
      recipe = recipe_fixture()
      assert Recipes.get_recipe(recipe.recipe_link) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(@valid_attrs)
      assert recipe.collections == []
      assert recipe.description == "some description"
      assert recipe.difficulty == "some difficulty"
      assert recipe.images == []
      assert recipe.ingredients == []
      assert recipe.likes == 42
      assert recipe.method == []
      assert recipe.name == "some name"
      assert recipe.source == "some source"
      assert recipe.total_time == "some total_time"
      assert recipe.views == 42
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, @update_attrs)
      assert recipe.collections == []
      assert recipe.description == "some updated description"
      assert recipe.difficulty == "some updated difficulty"
      assert recipe.images == []
      assert recipe.ingredients == []
      assert recipe.likes == 43
      assert recipe.method == []
      assert recipe.name == "some updated name"
      assert recipe.source == "some updated source"
      assert recipe.total_time == "some updated total_time"
      assert recipe.views == 43
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe(recipe.recipe_link)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe(recipe.recipe_link) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end
  end
end
