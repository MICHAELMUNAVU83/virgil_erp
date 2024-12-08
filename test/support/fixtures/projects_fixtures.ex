defmodule VirgilErp.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        design_link: "some design_link",
        stage: "some stage",
        system_link: "some system_link",
        title: "some title",
        total_payment: 42
      })
      |> VirgilErp.Projects.create_project()

    project
  end
end
