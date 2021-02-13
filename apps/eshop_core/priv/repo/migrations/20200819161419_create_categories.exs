defmodule EshopCore.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string

      timestamps(default: fragment("NOW()"))
    end
  end
end
