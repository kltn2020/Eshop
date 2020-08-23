defmodule Eshop.Repo.Migrations.CreateVouchers do
  use Ecto.Migration

  def change do
    create table(:vouchers) do
      add :code, :string
      add :valid_from, :naive_datetime
      add :valid_to, :naive_datetime
      add :is_used, :boolean, default: true, null: false
      add :value, :integer, default: 0
      add :category_id, references(:categories, on_delete: :delete_all)

      timestamps(default: fragment("NOW()"))
    end

    create unique_index(:vouchers, [:code])
    create index(:vouchers, [:category_id])
  end
end
