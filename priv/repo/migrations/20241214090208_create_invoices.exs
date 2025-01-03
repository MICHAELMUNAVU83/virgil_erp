defmodule VirgilErp.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :amount, :float
      add :client, :string
      add :invoice_id, :string
      add :pdf_attachment, :text
      add :is_paid, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:invoices, [:user_id])
    create index(:invoices, [:project_id])
  end
end
