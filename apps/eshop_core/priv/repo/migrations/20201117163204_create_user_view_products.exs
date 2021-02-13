defmodule EshopCore.Repo.Migrations.CreateUserViewProducts do
  use Ecto.Migration

  def change do
    create table(:user_view_products) do
      add :view_at, :naive_datetime, default: fragment("now()")
      add :user_id, references(:users, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps(default: fragment("NOW()"))
    end

    create index(:user_view_products, [:user_id])
    create index(:user_view_products, [:product_id])
  end
end
