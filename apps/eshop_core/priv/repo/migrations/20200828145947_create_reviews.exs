defmodule EshopCore.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :content, :text
      add :point, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps(default: fragment("NOW()"))
    end

    create index(:reviews, [:user_id])
    create index(:reviews, [:product_id])
  end
end
