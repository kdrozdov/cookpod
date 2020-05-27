defmodule Cookpod.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query

  alias Cookpod.Repo
  alias Cookpod.Recipes.{Recipe, RecipeFsm, ViewCounter}

  def list_recipes do
    Recipe
    |> where(state: ^RecipeFsm.state(:published))
    |> Repo.all()
  end

  def list_drafts do
    Recipe
    |> where(state: ^RecipeFsm.state(:draft))
    |> Repo.all()
  end

  def get_recipe!(id) do
    Recipe
    |> where([r], r.id == ^id)
    |> join(:left, [r], i in assoc(r, :ingredients))
    |> join(:left, [r, i], p in assoc(i, :product))
    |> preload([r, i, p], ingredients: {i, product: p})
    |> Repo.one!()
  end

  def new_recipe(), do: Recipe.new()

  def publish_recipe(recipe), do: RecipeFsm.event(recipe, :publish)
  def unpublish_recipe(recipe), do: RecipeFsm.event(recipe, :unpublish)

  def increment_recipe_views(id), do: ViewCounter.increment(id)
  def view_stats_stream(), do: ViewCounter.stats_stream()

  def create_recipe(attrs \\ %{}) do
    %Recipe{state: RecipeFsm.initial_state()}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end

  def recipe_nutrients(%Recipe{} = recipe), do: Recipe.nutrients(recipe)

  alias Cookpod.Recipes.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end

  alias Cookpod.Recipes.Ingredient

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient changes.

  ## Examples

      iex> change_ingredient(ingredient)
      %Ecto.Changeset{source: %Ingredient{}}

  """
  def change_ingredient(%Ingredient{} = ingredient) do
    Ingredient.changeset(ingredient, %{})
  end
end
