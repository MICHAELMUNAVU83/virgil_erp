defmodule VirgilErp.ProjectTaskAssignees.ProjectTaskAssignee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_task_assignees" do

    field :project_task_id, :id
    field :assignee_id, :id
    field :assigner_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project_task_assignee, attrs) do
    project_task_assignee
    |> cast(attrs, [])
    |> validate_required([])
  end
end
