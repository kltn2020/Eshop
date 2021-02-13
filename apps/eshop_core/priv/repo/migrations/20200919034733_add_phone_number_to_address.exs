defmodule EshopCore.Repo.Migrations.AddPhoneNumberToAddress do
  use Ecto.Migration

  def change do
    alter table("addresses") do
      add :phone_number, :text
    end
  end
end
