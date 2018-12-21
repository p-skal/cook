defmodule Cook.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes, primary_key: false) do
      add(:id, :binary_id, primary_key: true, null: false)
      add :name, :string, null: false
      add :slug, :string
      add :description, :string
      add :difficulty, :string, default: "Easy", null: false
      add :total_time, :string, default: "30 mins", null: false
      add(:ingredients, :jsonb, default: "[]", primary_key: false)
      add :method, {:array, :string}, null: false
      add :images, {:array, :string}
      add :source, :string
      add :likes, :integer, default: 0
      add :views, :integer, default: 0
      add :collections, {:array, :string}, null: false

      add(:user_id, references(:users, type: :binary_id))

      timestamps(inserted_at: :created_at)
    end

    create index(:recipes, [:slug])
  end
end
