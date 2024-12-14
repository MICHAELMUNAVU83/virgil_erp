defmodule VirgilErp.ProjectTasksTest do
  use VirgilErp.DataCase

  alias VirgilErp.ProjectTasks

  describe "project_tasks" do
    alias VirgilErp.ProjectTasks.ProjectTask

    import VirgilErp.ProjectTasksFixtures

    @invalid_attrs %{attachment: nil, description: nil, priority: nil, title: nil, type: nil}

    test "list_project_tasks/0 returns all project_tasks" do
      project_task = project_task_fixture()
      assert ProjectTasks.list_project_tasks() == [project_task]
    end

    test "get_project_task!/1 returns the project_task with given id" do
      project_task = project_task_fixture()
      assert ProjectTasks.get_project_task!(project_task.id) == project_task
    end

    test "create_project_task/1 with valid data creates a project_task" do
      valid_attrs = %{attachment: "some attachment", description: "some description", priority: "some priority", title: "some title", type: "some type"}

      assert {:ok, %ProjectTask{} = project_task} = ProjectTasks.create_project_task(valid_attrs)
      assert project_task.attachment == "some attachment"
      assert project_task.description == "some description"
      assert project_task.priority == "some priority"
      assert project_task.title == "some title"
      assert project_task.type == "some type"
    end

    test "create_project_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectTasks.create_project_task(@invalid_attrs)
    end

    test "update_project_task/2 with valid data updates the project_task" do
      project_task = project_task_fixture()
      update_attrs = %{attachment: "some updated attachment", description: "some updated description", priority: "some updated priority", title: "some updated title", type: "some updated type"}

      assert {:ok, %ProjectTask{} = project_task} = ProjectTasks.update_project_task(project_task, update_attrs)
      assert project_task.attachment == "some updated attachment"
      assert project_task.description == "some updated description"
      assert project_task.priority == "some updated priority"
      assert project_task.title == "some updated title"
      assert project_task.type == "some updated type"
    end

    test "update_project_task/2 with invalid data returns error changeset" do
      project_task = project_task_fixture()
      assert {:error, %Ecto.Changeset{}} = ProjectTasks.update_project_task(project_task, @invalid_attrs)
      assert project_task == ProjectTasks.get_project_task!(project_task.id)
    end

    test "delete_project_task/1 deletes the project_task" do
      project_task = project_task_fixture()
      assert {:ok, %ProjectTask{}} = ProjectTasks.delete_project_task(project_task)
      assert_raise Ecto.NoResultsError, fn -> ProjectTasks.get_project_task!(project_task.id) end
    end

    test "change_project_task/1 returns a project_task changeset" do
      project_task = project_task_fixture()
      assert %Ecto.Changeset{} = ProjectTasks.change_project_task(project_task)
    end
  end
end
