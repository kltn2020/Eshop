defmodule EshopCore.Repo.Migrations.CreateFavorites do
  use Ecto.Migration

  def change do
    create table(:favorites) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps(default: fragment("NOW()"))
    end

    create index(:favorites, [:user_id])
    create index(:favorites, [:product_id])
    create unique_index(:favorites, [:user_id, :product_id])
  end
end
