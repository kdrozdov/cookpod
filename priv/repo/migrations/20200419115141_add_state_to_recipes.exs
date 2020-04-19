defmodule Cookpod.Repo.Migrations.AddStateToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :state, :text
    end
  end
end
