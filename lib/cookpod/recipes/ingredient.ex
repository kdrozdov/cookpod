defmodule Cookpod.Recipes.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cookpod.Recipes.{Recipe,Product,Nutrients}

  schema "ingredients" do
    field :amount, :integer, default: 0
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true
    belongs_to :recipe, Recipe
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> Map.put(:temp_id, (ingredient.temp_id || attrs["temp_id"]))
    |> cast(attrs, [:amount, :product_id, :delete])
    |> validate_required([:amount, :product_id])
    |> unique_constraint(:product_id, name: :ingredients_recipe_id_product_id_index)
    |> maybe_mark_for_deletion()
  end

  def nutrients(ingredient) do
    product_nutrients = Product.nutrients(ingredient.product)
    proportion = ingredient.amount / Product.nutrients_weight
    Nutrients.mult_by_value(product_nutrients, proportion)
  end

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
