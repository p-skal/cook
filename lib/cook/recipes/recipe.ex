defmodule Cook.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cook.Accounts.User
  alias Cook.Recipes.Recipe

  @total_time_options ["10 mins", "20 mins", "30 mins", "45 mins", "1h", "+1h"]
  @difficulty_levels ["Very Easy", "Easy", "Intermediate", "Difficult"]
  @ingredient_unit_options [
    "",
    "millimetre(s)",
    "centimetre(s)",
    "metre(s)",
    "milligram(s)",
    "gram(s)",
    "kilogram(s)",
    "litre(s)",
    "millilitre(s)",
    "cup(s)",
    "teaspoon(s)",
    "tablespoon(s)",
    "pinch(es)",
    "quart(s)",
    "ounce(s)",
    "pint(s)"
  ]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipes" do
    field :collections, {:array, :string}
    field :slug, :string, unique: true
    field :description, :string
    field :difficulty, :string
    field :images, {:array, :string}

    embeds_many :ingredients, Ingredient, primary_key: false do
      field :name, :string
      field :quantity, :decimal
      field :unit, :string
    end

    field :likes, :integer
    field :method, {:array, :string}
    field :name, :string
    field :source, :string
    field :total_time, :string
    field :views, :integer

    belongs_to(:user, User, foreign_key: :user_id)

    timestamps(inserted_at: :created_at)
  end

  def total_time_options, do: @total_time_options
  def difficulty_levels, do: @difficulty_levels
  def ingredient_unit_options, do: @ingredient_unit_options

  @doc false
  def changeset(%Recipe{} = recipe, attrs) do
    recipe
    |> cast(attrs, [
      :name,
      :slug,
      :description,
      :difficulty,
      :total_time,
      :method,
      :images,
      :likes,
      :views,
      :collections
    ])
    |> validate_required([
      :name,
      :difficulty,
      :total_time,
      :method,
      :collections
    ])
    |> validate_length(:name,
      min: 2,
      max: 45,
      message: "The recipe name must be 5-45 characters long."
    )
    |> validate_length(:description,
      max: 255,
      message: "The recipe description cannot be any longer than 255 characters."
    )
    |> slugify_name()
    |> unique_constraint(:slug)
    |> validate_inclusion(:total_time, @total_time_options)
    |> validate_inclusion(:difficulty, @difficulty_levels)
    |> cast_embed(:ingredients, with: &ingredients_changeset/2)
  end

  defp ingredients_changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :quantity, :unit])
    |> validate_required([:name, :quantity, :unit])
    |> validate_inclusion(:unit, @ingredient_unit_options)
  end

  defp slugify_name(changeset) do
    if name = get_change(changeset, :name) do
      put_change(changeset, :slug, slugify(name))
    else
      changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
