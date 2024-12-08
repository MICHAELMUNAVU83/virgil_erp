defmodule VirgilErp.ProjectsTest do
  use VirgilErp.DataCase

  alias VirgilErp.Projects

  describe "projects" do
    alias VirgilErp.Projects.Project

    import VirgilErp.ProjectsFixtures

    @invalid_attrs %{description: nil, design_link: nil, stage: nil, system_link: nil, title: nil, total_payment: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{description: "some description", design_link: "some design_link", stage: "some stage", system_link: "some system_link", title: "some title", total_payment: 42}

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.description == "some description"
      assert project.design_link == "some design_link"
      assert project.stage == "some stage"
      assert project.system_link == "some system_link"
      assert project.title == "some title"
      assert project.total_payment == 42
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{description: "some updated description", design_link: "some updated design_link", stage: "some updated stage", system_link: "some updated system_link", title: "some updated title", total_payment: 43}

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.description == "some updated description"
      assert project.design_link == "some updated design_link"
      assert project.stage == "some updated stage"
      assert project.system_link == "some updated system_link"
      assert project.title == "some updated title"
      assert project.total_payment == 43
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end
