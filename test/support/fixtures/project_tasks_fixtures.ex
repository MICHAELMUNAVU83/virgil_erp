defmodule VirgilErp.ProjectTasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.ProjectTasks` context.
  """

  @doc """
  Generate a project_task.
  """
  def project_task_fixture(attrs \\ %{}) do
    {:ok, project_task} =
      attrs
      |> Enum.into(%{
        attachment: "some attachment",
        description: "some description",
        priority: "some priority",
        title: "some title",
        type: "some type"
      })
      |> VirgilErp.ProjectTasks.create_project_task()

    project_task
  end
end
