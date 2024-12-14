defmodule VirgilErp.ProjectTaskComments.ProjectTaskComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_task_comments" do
    field :attachment, :string
    field :comment, :string
    field :project_id, :id
    field :project_task_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project_task_comment, attrs) do
    project_task_comment
    |> cast(attrs, [:comment, :attachment])
    |> validate_required([:comment, :attachment])
  end
end
