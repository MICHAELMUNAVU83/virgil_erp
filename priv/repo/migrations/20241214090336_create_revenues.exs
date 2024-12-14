defmodule VirgilErp.Repo.Migrations.CreateRevenues do
  use Ecto.Migration

  def change do
    create table(:revenues) do
      add :amount, :float
      add :paid_through, :string
      add :reason, :text
      add :paid_at, :date
      add :project_id, references(:projects, on_delete: :nothing)
      add :invoice_id, references(:invoices, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:revenues, [:project_id])
    create index(:revenues, [:invoice_id])
    create index(:revenues, [:user_id])
  end
end
