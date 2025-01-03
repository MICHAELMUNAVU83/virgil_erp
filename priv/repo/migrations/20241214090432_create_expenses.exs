defmodule VirgilErp.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :amount, :float
      add :reason, :text
      add :paid_at, :date
      add :attached_receipt, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:expenses, [:user_id])
  end
end
