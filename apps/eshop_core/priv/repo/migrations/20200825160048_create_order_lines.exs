defmodule EshopCore.Repo.Migrations.CreateOrderLines do
  use Ecto.Migration

  def change do
    create table(:order_lines) do
      add :product_id, references(:products, on_delete: :delete_all)
      add :order_id, references(:orders, on_delete: :delete_all)
      add :quantity, :integer, default: 0
      add :price, :integer, default: 0
      add :discount, :bigint, default: 0
      add :total, :bigint, default: 0

      timestamps(default: fragment("NOW()"))
    end

    create index(:order_lines, [:product_id])
    create index(:order_lines, [:order_id])
  end
end
