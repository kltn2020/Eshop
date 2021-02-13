defmodule EshopCore.Repo.Migrations.AddImageToProducts do
  use Ecto.Migration

  def change do
    alter table("products") do
      add :images, :jsonb, default: "[]"
    end
  end
end
