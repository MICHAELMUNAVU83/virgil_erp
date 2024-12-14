defmodule VirgilErp.Repo.Migrations.CreateProjectTasks do
  use Ecto.Migration

  def change do
    create table(:project_tasks) do
      add :title, :string
      add :description, :text
      add :type, :string
      add :priority, :string
      add :attachment, :text
      add :project_id, references(:projects, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:project_tasks, [:project_id])
    create index(:project_tasks, [:user_id])
  end
end
