defmodule Eshop.Repo.Migrations.AddDiscountPriceToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :price
      remove :discount

      add :price, :bigint
      add :discount_price, :bigint
    end
  end
end
