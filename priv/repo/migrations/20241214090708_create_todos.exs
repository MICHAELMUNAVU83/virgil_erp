defmodule VirgilErp.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string
      add :description, :text
      add :due_by, :utc_datetime
      add :remind_at, :utc_datetime
      add :remind_by, :utc_datetime
      add :is_completed, :boolean, default: false, null: false
      add :assignee_id, references(:users, on_delete: :nothing)
      add :assigneer_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:todos, [:assignee_id])
    create index(:todos, [:assigneer_id])
  end
end
