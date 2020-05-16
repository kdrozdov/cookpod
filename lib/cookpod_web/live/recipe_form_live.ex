defmodule CookpodWeb.RecipeFormLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Cookpod.Recipes
  alias Cookpod.Recipes.{Recipe,Ingredient}

  def mount(_params, session, socket) do
    recipe = get_recipe(session)

    assigns = [
      conn: socket,
      action: Map.fetch!(session, "action"),
      csrf_token: Map.fetch!(session, "csrf_token"),
      back_path: Map.fetch!(session, "back_path"),
      changeset: Recipes.change_recipe(recipe),
      recipe: recipe,
      nutrients: Recipes.recipe_nutrients(recipe)
    ]

    {:ok, assign(socket, assigns)}
  end

  def handle_event("form_changed", %{"recipe" => recipe_params}, socket) do
    changeset =
      socket.assigns.recipe
      |> Recipe.changeset(recipe_params)
      |> Map.put(:action, :insert)

    nutrients =
      changeset
      |> Ecto.Changeset.apply_changes()
      |> get_nutrients()

    {:noreply, assign(socket, changeset: changeset, nutrients: nutrients)}
  end

  def handle_event("add_ingredient", _, socket) do
    existing_ingredients =
      socket.assigns.changeset.changes
      |> Map.get(:ingredients, socket.assigns.recipe.ingredients)

    position = length(existing_ingredients) + 1
    ingredients =
      existing_ingredients
      |> Enum.concat([
        Recipes.change_ingredient(%Ingredient{temp_id: get_temp_id(position)})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:ingredients, ingredients)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove_ingredient", %{"remove" => id}, socket) do
    ingredients =
      socket.assigns.changeset.changes.ingredients
      |> Enum.reject(fn %{data: ingredient} ->
        ingredient.temp_id == id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:ingredients, ingredients)

    nutrients =
      changeset
      |> Ecto.Changeset.apply_changes()
      |> get_nutrients()

    {:noreply, assign(socket, changeset: changeset, nutrients: nutrients)}
  end

  def render(assigns) do
    CookpodWeb.RecipeView.render("form.html", assigns)
  end

  defp get_recipe(%{"id" => id} = _product_params), do: Recipes.get_recipe!(id)
  defp get_recipe(_product_params), do: Recipes.new_recipe()

  defp get_temp_id(position) do
    to_string(:os.system_time(:millisecond) + position)
  end

  defp get_nutrients(recipe) do
    ingredients =
      recipe.ingredients
      |> Enum.reject(fn ingredient ->
        ingredient.delete == "true" ||
          is_nil(ingredient.product_id)
      end)
      |> Cookpod.Repo.preload(:product)

    recipe
    |> Map.put(:ingredients, ingredients)
    |> Recipes.recipe_nutrients()
  end
end
