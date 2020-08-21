defmodule Eshop.Repo.Migrations.CreateCartProducts do
  use Ecto.Migration

  def change do
    create table(:cart_products, primary_key: false) do
      add :quantity, :integer, default: 1
      add :cart_id, references(:carts, on_delete: :delete_all), primary_key: true
      add :product_id, references(:products, on_delete: :delete_all), primary_key: true

      timestamps(default: fragment("NOW()"))
    end

    create index(:cart_products, [:cart_id])
    create index(:cart_products, [:product_id])
  end
end
