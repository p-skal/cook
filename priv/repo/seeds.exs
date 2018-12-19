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
