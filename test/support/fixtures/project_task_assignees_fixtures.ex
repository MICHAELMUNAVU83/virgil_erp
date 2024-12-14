defmodule VirgilErp.ProjectTaskAssigneesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.ProjectTaskAssignees` context.
  """

  @doc """
  Generate a project_task_assignee.
  """
  def project_task_assignee_fixture(attrs \\ %{}) do
    {:ok, project_task_assignee} =
      attrs
      |> Enum.into(%{

      })
      |> VirgilErp.ProjectTaskAssignees.create_project_task_assignee()

    project_task_assignee
  end
end
