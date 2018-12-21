defmodule Cook.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true, null: false)
      add(:handle, :string, null: false)
      add(:email, :string, null: false)
      add(:name, :string, null: false)
      add(:hash_password, :string, null: false)

      timestamps(inserted_at: :created_at)
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:handle]))
  end
end
