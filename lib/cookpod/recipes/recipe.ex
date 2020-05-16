defmodule Cookpod.Recipes.Recipe do
  @moduledoc false

  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Cookpod.Recipes.{RecipeFsm,Ingredient,Nutrients}

  schema "recipes" do
    field :description, :string
    field :name, :string
    field :picture, Cookpod.Recipes.Picture.Type
    field :state, :string
    has_many :ingredients, Ingredient
    has_many :products, through: [:ingredients, :product]

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :state])
    |> cast_attachments(attrs, [:picture])
    |> cast_assoc(:ingredients)
    |> validate_required([:name, :description, :state])
    |> validate_length(:name, min: 2)
    |> validate_length(:description, min: 10)
    |> validate_inclusion(:state, RecipeFsm.states() |> Map.values())
    |> unique_constraint(:name)
  end

  def new() do
    %__MODULE__{
      state: initial_state(),
      ingredients: []
    }
  end

  def initial_state(), do: RecipeFsm.initial_state()

  def nutrients(recipe) do
    Enum.reduce(recipe.ingredients, %Nutrients{}, fn ingredient, acc ->
      ingredient_nutrients = Ingredient.nutrients(ingredient)
      Nutrients.addition(ingredient_nutrients, acc)
    end)
  end
end
