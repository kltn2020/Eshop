defmodule EshopCore.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :discount, :bigint, default: 0
      add :total, :bigint, default: 0
      add :status, :string, default: "processing"
      add :order_date, :naive_datetime, default: fragment("now()")
      add :user_id, references(:users, on_delete: :delete_all)
      add :voucher_id, references(:vouchers, on_delete: :delete_all)
      add :address_id, references(:addresses, on_delete: :delete_all)

      timestamps(default: fragment("NOW()"))
    end

    create index(:orders, [:user_id])
    create index(:orders, [:voucher_id])
    create index(:orders, [:address_id])
  end
end
