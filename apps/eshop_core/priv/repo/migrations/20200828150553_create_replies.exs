defmodule EshopCore.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add :content, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :review_id, references(:reviews, on_delete: :delete_all)

      timestamps(default: fragment("NOW()"))
    end

    create index(:replies, [:user_id])
    create index(:replies, [:review_id])
  end
end
