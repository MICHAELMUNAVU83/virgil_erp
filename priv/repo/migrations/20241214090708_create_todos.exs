defmodule VirgilErp.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string
      add :description, :text
      add :due_by, :date
      add :remind_at, :utc_datetime
      add :is_completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:todos, [:user_id])
  end
end
