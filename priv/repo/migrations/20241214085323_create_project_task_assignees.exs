defmodule VirgilErp.Repo.Migrations.CreateProjectTaskAssignees do
  use Ecto.Migration

  def change do
    create table(:project_task_assignees) do
      add :project_task_id, references(:project_tasks, on_delete: :nothing)
      add :assignee_id, references(:users, on_delete: :nothing)
      add :assigner_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:project_task_assignees, [:project_task_id])
    create index(:project_task_assignees, [:assignee_id])
    create index(:project_task_assignees, [:assigner_id])
  end
end
