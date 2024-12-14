defmodule VirgilErp.Repo.Migrations.CreateProjectTaskComments do
  use Ecto.Migration

  def change do
    create table(:project_task_comments) do
      add :comment, :text
      add :attachment, :text
      add :project_id, references(:projects, on_delete: :nothing)
      add :project_task_id, references(:project_tasks, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:project_task_comments, [:project_id])
    create index(:project_task_comments, [:project_task_id])
    create index(:project_task_comments, [:user_id])
  end
end
