defmodule Cookpod.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email])
    |> validate_length(:password, min: 4)
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> validate_email()
    |> encrypt_password()
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

  defp validate_email(changeset, options \\ []) do
    validate_change(changeset, :email, fn field, email ->
      validation_result = Cookpod.Validators.EmailValidator.call(email)

      case validation_result do
        {:ok, _} -> []
        {:error, error} -> [{field, options[:message] || error}]
      end
    end)
  end
end
