defmodule VirgilErp.ProjectTaskCommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.ProjectTaskComments` context.
  """

  @doc """
  Generate a project_task_comment.
  """
  def project_task_comment_fixture(attrs \\ %{}) do
    {:ok, project_task_comment} =
      attrs
      |> Enum.into(%{
        attachment: "some attachment",
        comment: "some comment"
      })
      |> VirgilErp.ProjectTaskComments.create_project_task_comment()

    project_task_comment
  end
end
