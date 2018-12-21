# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cook.Repo.insert!(%Cook.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# users
user =
  Cook.Accounts.User.registration_changeset(%Cook.Accounts.User{}, %{
    handle: "some_handle",
    email: "some@email.com",
    name: "some name",
    password: "some password"
  })

Cook.Repo.insert!(user)

# recipes
recipe =
  Cook.Recipes.Recipe.changeset(%Cook.Recipes.Recipe{}, %{
    name: "My Tart",
    description: "A lemon tart with a wonderful biscuit-crumb base.",
    difficulty: "Intermediate",
    total_time: "30 mins",
    collections: ["Desserts"],
    ingredients: [
      %{name: "Biscuits", quantity: 100, unit: "gram(s)"},
      %{name: "Lemon", quantity: 100, unit: "gram(s)"}
    ],
    method: [
      "First, crush the biscuits and add them to the bowl.",
      "Then, grate the rind off of the lemons and add it in too."
    ],
    source: "Vanilla Oakleigh"
  })

recipe2 =
  Cook.Recipes.Recipe.changeset(%Cook.Recipes.Recipe{}, %{
    name: "Hot Cocoa",
    description: "A smooth and heart-warming hot cocoa.",
    difficulty: "Very Easy",
    total_time: "10 mins",
    collections: ["Beverages"],
    ingredients: [
      %{name: "Cocoa Powder", quantity: 50, unit: "tablespoon(s)"},
      %{name: "Milk", quantity: 1, unit: "cup(s)"}
    ],
    method: [
      "First, put the cocoa powder in a cup with boiling water.",
      "Then, pour the 200g of milk into a cup and froth it to your liking.",
      "Finally, pour the frothed milk into the cocoa solution."
    ]
  })

recipe3 =
  Cook.Recipes.Recipe.changeset(%Cook.Recipes.Recipe{}, %{
    name: "Chocolate Brownie",
    description: "A smooth and heart-warming chocolate brownie.",
    difficulty: "Easy",
    total_time: "30 mins",
    collections: ["Beverages"],
    ingredients: [
      %{name: "Cocoa Powder", quantity: 1, unit: "cup(s)"},
      %{name: "Flour", quantity: 200, unit: "gram(s)"}
    ],
    method: [
      "First, put the cocoa powder in a cup with boiling water.",
      "Then, pour the 200g of milk into a cup and froth it to your liking.",
      "Finally, pour the frothed milk into the cocoa solution."
    ]
  })

Cook.Repo.insert!(recipe)
Cook.Repo.insert!(recipe2)
Cook.Repo.insert!(recipe3)
