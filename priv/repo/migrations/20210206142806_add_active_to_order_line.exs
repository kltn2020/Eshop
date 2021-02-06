defmodule Eshop.Repo.Migrations.AddActiveToOrderLine do
  use Ecto.Migration

  def change do
    alter table(:cart_products) do
      add :active, :boolean, default: true
    end

  end
end
