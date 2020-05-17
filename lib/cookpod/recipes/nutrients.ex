defmodule Cookpod.Recipes.Nutrients do
  @moduledoc false

  @calories_in_carbs 4
  @calories_in_fats 9
  @calories_in_proteins 4

  defstruct carbs: 0, fats: 0, proteins: 0, calories: 0

  def new(%{carbs: carbs, fats: fats, proteins: proteins} = params) do
    %__MODULE__{
      carbs: carbs,
      fats: fats,
      proteins: proteins,
      calories: calc_calories(params)
    }
  end

  def mult_by_value(nutrients, value) do
    new(%{
      carbs: Float.round(nutrients.carbs * value),
      fats: Float.round(nutrients.fats * value),
      proteins: Float.round(nutrients.proteins * value)
    })
  end

  def addition(nutrients1, nutrients2) do
    new(%{
      carbs: nutrients1.carbs + nutrients2.carbs,
      fats: nutrients1.fats + nutrients2.fats,
      proteins: nutrients1.proteins + nutrients2.proteins
    })
  end

  defp calc_calories(%{carbs: carbs, fats: fats, proteins: proteins}) do
    carbs * @calories_in_carbs +
      fats * @calories_in_fats +
      proteins * @calories_in_proteins
  end
end
