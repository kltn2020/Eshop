defmodule Eshop.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :sku, :string, unique: true
      add :name, :string, unique: true
      add :price, :float, default: 0
      add :discount, :float, default: 0
      add :cpu, :string
      add :gpu, :string
      add :os, :string
      add :ram, :string
      add :storage, :string
      add :new_feature, :string
      add :display, :string
      add :display_resolution, :string
      add :display_screen, :string
      add :camera, :string
      add :video, :string
      add :wifi, :string
      add :bluetooth, :string
      add :ports, :string
      add :size, :string
      add :weight, :string
      add :material, :string
      add :battery_capacity, :string
      add :description, :string
      add :sold, :integer, default: 0
      add :content, :string
      add :rating_avg, :float, default: 0
      add :rating_count, :integer, default: 0
      add :category_id, references(:categories, on_delete: :delete_all)
      add :brand_id, references(:brands, on_delete: :delete_all)

      timestamps(default: fragment("NOW()"))
    end

    create index(:products, [:category_id])
    create index(:products, [:brand_id])
  end
end
