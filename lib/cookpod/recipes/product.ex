defmodule Cookpod.Recipes.Product do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Cookpod.Recipes.Nutrients

  schema "products" do
    field :name, :string
    field :carbs, :integer
    field :fats, :integer
    field :proteins, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :fats, :carbs, :proteins])
    |> validate_required([:name, :fats, :carbs, :proteins])
    |> unique_constraint(:name)
  end

  def nutrients_weight(), do: 100

  def nutrients(product) do
    Nutrients.new(%{
      carbs: product.carbs,
      fats: product.fats,
      proteins: product.proteins
    })
  end
end
