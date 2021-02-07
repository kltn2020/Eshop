defmodule Eshop.Repo.Migrations.AddSenderEmail do
  use Ecto.Migration

  def change do
    alter table(:general_settings) do
      add :sender_email, :text
    end
  end
end
