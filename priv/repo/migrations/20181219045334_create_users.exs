defmodule Cook.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:handle, :string, null: false)
      add(:email, :string, null: false)
      add(:name, :string, null: false)
      add(:hash_password, :string, null: false)

      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:handle]))
  end
end
