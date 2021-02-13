defmodule EshopCore.Repo.Migrations.RemoveContent do
  use Ecto.Migration

  def change do
    alter table("products") do
      remove :content
    end
  end
end
