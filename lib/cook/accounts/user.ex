defmodule Cook.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cook.Accounts.User

  schema "users" do
    field :handle, :string
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :hash_password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :handle])
    |> validate_required([:name, :email, :handle])
    |> validate_length(:handle,
      min: 3,
      max: 20,
      message: "Your handle must be 3-20 characters long."
    )
    |> validate_length(:name, min: 2, max: 255, message: "Your name must be 2-255 characters long")
    |> validate_length(:email,
      min: 5,
      max: 255,
      message: "Your email address must be 5-255 characters long."
    )
    |> unique_constraint(:email, message: "That email address has already been taken!")
    |> unique_constraint(:handle, message: "That handle has already been taken!")
    |> validate_format(:email, ~r/@/, message: "You've entered an invalid email address!")
  end

  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 100)
    |> put_hash_password()
  end

  defp put_hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :hash_password, Comeonin.Argon2.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
