defmodule VirgilErp.ProjectTasks.ProjectTask do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_tasks" do
    field :attachment, :string
    field :description, :string
    field :priority, :string
    field :title, :string
    field :type, :string
    belongs_to :project, VirgilErp.Projects.Project
    belongs_to :user, VirgilErp.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project_task, attrs) do
    project_task
    |> cast(attrs, [:title, :description, :type, :priority, :attachment, :project_id, :user_id])
    |> validate_required([
      :title,
      :description,
      :type,
      :priority,
      :attachment,
      :project_id,
      :user_id
    ])
  end
end
