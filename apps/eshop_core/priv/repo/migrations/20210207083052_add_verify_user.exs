defmodule EshopCore.Repo.Migrations.AddVerifyUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :verify, :boolean, default: false
      add :token, :text
      add :token_expired_at, :naive_datetime
    end
  end
end
