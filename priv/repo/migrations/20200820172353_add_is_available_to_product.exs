defmodule Eshop.Repo.Migrations.AddIsAvailableToProduct do
  use Ecto.Migration

  def change do
    alter table("products") do
      add :is_available, :boolean, default: true
    end

    create index(:products, [:is_available])
  end
end
