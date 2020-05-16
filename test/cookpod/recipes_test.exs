defmodule Cookpod.RecipesTest do
  use Cookpod.DataCase

  alias Cookpod.Recipes

  describe "recipes" do
    alias Cookpod.Recipes.Recipe

    @valid_attrs %{
      description: "some description",
      name: "some name",
      state: "draft"
    }
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil, picture: nil}

    test "list_recipes/0 returns all published recipes" do
      recipe = insert(:recipe, %{state: "published"})
      assert Recipes.list_recipes() == [recipe]
    end

    test "list_drafts/0 returns all drafts" do
      recipe = insert(:recipe, %{state: "draft"})
      assert Recipes.list_drafts() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = insert(:recipe)
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(@valid_attrs)
      assert recipe.description == "some description"
      assert recipe.name == "some name"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = insert(:recipe)
      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, @update_attrs)
      assert recipe.description == "some updated description"
      assert recipe.name == "some updated name"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = insert(:recipe)
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = insert(:recipe)
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "publish_recipe/1 changes state to published if recipe is draft" do
      recipe = insert(:recipe, %{state: "draft"})
      assert {:ok, recipe} = Recipes.publish_recipe(recipe)
      assert recipe.state == "published"
    end

    test "unpublish_recipe/1 changes state to draft if recipe is published" do
      recipe = insert(:recipe, %{state: "published"})
      assert {:ok, recipe} = Recipes.unpublish_recipe(recipe)
      assert recipe.state == "draft"
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = insert(:recipe)
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end
  end

  describe "products" do
    alias Cookpod.Recipes.Product

    @valid_attrs %{carbs: 42, fats: 42, name: "some name", proteins: 42}
    @update_attrs %{carbs: 43, fats: 43, name: "some updated name", proteins: 43}
    @invalid_attrs %{carbs: nil, fats: nil, name: nil, proteins: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Recipes.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Recipes.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Recipes.create_product(@valid_attrs)
      assert product.carbs == 42
      assert product.fats == 42
      assert product.name == "some name"
      assert product.proteins == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Recipes.update_product(product, @update_attrs)
      assert product.carbs == 43
      assert product.fats == 43
      assert product.name == "some updated name"
      assert product.proteins == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_product(product, @invalid_attrs)
      assert product == Recipes.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Recipes.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Recipes.change_product(product)
    end
  end

  describe "ingredients" do
    alias Cookpod.Recipes.Ingredient

    @valid_attrs %{amount: 42}
    @update_attrs %{amount: 43}
    @invalid_attrs %{amount: nil}

    def ingredient_fixture(attrs \\ %{}) do
      {:ok, ingredient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_ingredient()

      ingredient
    end

    test "list_ingredients/0 returns all ingredients" do
      ingredients = ingredient_fixture()
      assert Recipes.list_ingredients() == [ingredients]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Recipes.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      assert {:ok, %Ingredient{} = ingredient} = Recipes.create_ingredient(@valid_attrs)
      assert ingredient.amount == 42
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{} = ingredient} = Recipes.update_ingredient(ingredient, @update_attrs)
      assert ingredient.amount == 43
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Recipes.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Recipes.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Recipes.change_ingredient(ingredient)
    end
  end
end
