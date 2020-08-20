defmodule Eshop.Repo.Migrations.AddUniqSku do
  use Ecto.Migration

  def change do
    create unique_index(:products, [:sku])
  end
end
