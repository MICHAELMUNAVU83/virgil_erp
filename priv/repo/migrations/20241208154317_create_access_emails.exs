defmodule VirgilErp.Repo.Migrations.CreateAccessEmails do
  use Ecto.Migration

  def change do
    create table(:access_emails) do
      add :active, :boolean, default: false, null: false
      add :owner_id, references(:users, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:access_emails, [:owner_id])
    create index(:access_emails, [:user_id])
    create index(:access_emails, [:project_id])
  end
end
