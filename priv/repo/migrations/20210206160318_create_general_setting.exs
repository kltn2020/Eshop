defmodule Eshop.Repo.Migrations.CreateGeneralSetting do
  use Ecto.Migration

  def change do
    create table(:general_settings) do
      add :limit, :integer

      timestamps(default: fragment("NOW()"))
    end
  end
end
