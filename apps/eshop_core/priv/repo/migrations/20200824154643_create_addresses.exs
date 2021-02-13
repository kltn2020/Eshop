defmodule EshopCore.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :is_primary, :boolean, default: false, null: false
      add :locate, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(default: fragment("NOW()"))
    end

    create index(:addresses, [:user_id])
  end
end
