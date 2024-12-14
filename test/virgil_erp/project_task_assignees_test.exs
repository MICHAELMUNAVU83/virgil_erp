defmodule VirgilErp.ProjectTaskAssigneesTest do
  use VirgilErp.DataCase

  alias VirgilErp.ProjectTaskAssignees

  describe "project_task_assignees" do
    alias VirgilErp.ProjectTaskAssignees.ProjectTaskAssignee

    import VirgilErp.ProjectTaskAssigneesFixtures

    @invalid_attrs %{}

    test "list_project_task_assignees/0 returns all project_task_assignees" do
      project_task_assignee = project_task_assignee_fixture()
      assert ProjectTaskAssignees.list_project_task_assignees() == [project_task_assignee]
    end

    test "get_project_task_assignee!/1 returns the project_task_assignee with given id" do
      project_task_assignee = project_task_assignee_fixture()
      assert ProjectTaskAssignees.get_project_task_assignee!(project_task_assignee.id) == project_task_assignee
    end

    test "create_project_task_assignee/1 with valid data creates a project_task_assignee" do
      valid_attrs = %{}

      assert {:ok, %ProjectTaskAssignee{} = project_task_assignee} = ProjectTaskAssignees.create_project_task_assignee(valid_attrs)
    end

    test "create_project_task_assignee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectTaskAssignees.create_project_task_assignee(@invalid_attrs)
    end

    test "update_project_task_assignee/2 with valid data updates the project_task_assignee" do
      project_task_assignee = project_task_assignee_fixture()
      update_attrs = %{}

      assert {:ok, %ProjectTaskAssignee{} = project_task_assignee} = ProjectTaskAssignees.update_project_task_assignee(project_task_assignee, update_attrs)
    end

    test "update_project_task_assignee/2 with invalid data returns error changeset" do
      project_task_assignee = project_task_assignee_fixture()
      assert {:error, %Ecto.Changeset{}} = ProjectTaskAssignees.update_project_task_assignee(project_task_assignee, @invalid_attrs)
      assert project_task_assignee == ProjectTaskAssignees.get_project_task_assignee!(project_task_assignee.id)
    end

    test "delete_project_task_assignee/1 deletes the project_task_assignee" do
      project_task_assignee = project_task_assignee_fixture()
      assert {:ok, %ProjectTaskAssignee{}} = ProjectTaskAssignees.delete_project_task_assignee(project_task_assignee)
      assert_raise Ecto.NoResultsError, fn -> ProjectTaskAssignees.get_project_task_assignee!(project_task_assignee.id) end
    end

    test "change_project_task_assignee/1 returns a project_task_assignee changeset" do
      project_task_assignee = project_task_assignee_fixture()
      assert %Ecto.Changeset{} = ProjectTaskAssignees.change_project_task_assignee(project_task_assignee)
    end
  end
end
