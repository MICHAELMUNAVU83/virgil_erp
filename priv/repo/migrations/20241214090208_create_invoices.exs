defmodule VirgilErp.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :invoice_id, :text
      add :amount, :float
      add :pay_by_date, :date
      add :terms_and_conditions, :text
      add :client, :string
      add :is_paid, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:invoices, [:user_id])
    create index(:invoices, [:project_id])
  end
end
