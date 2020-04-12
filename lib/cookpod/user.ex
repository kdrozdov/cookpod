defmodule Cookpod.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cookpod.Validators.EmailValidator

  schema "users" do
    field :email, :string
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs, opts \\ []) do
    email_validator = opts[:email_validator] || EmailValidator
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> validate_length(:password, min: 4)
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> email_validator.call(:email)
    |> encrypt_password()
  end

  def new_changeset() do
    changeset(%Cookpod.User{}, %{})
  end

  defp encrypt_password(changeset) do
    case Map.fetch(changeset.changes, :password) do
      {:ok, password} ->
        put_change(
          changeset,
          :encrypted_password,
          Argon2.hash_pwd_salt(password)
        )

      _ ->
        changeset
    end
  end
end
