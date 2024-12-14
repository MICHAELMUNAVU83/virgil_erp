defmodule VirgilErp.ProjectTaskCommentsTest do
  use VirgilErp.DataCase

  alias VirgilErp.ProjectTaskComments

  describe "project_task_comments" do
    alias VirgilErp.ProjectTaskComments.ProjectTaskComment

    import VirgilErp.ProjectTaskCommentsFixtures

    @invalid_attrs %{attachment: nil, comment: nil}

    test "list_project_task_comments/0 returns all project_task_comments" do
      project_task_comment = project_task_comment_fixture()
      assert ProjectTaskComments.list_project_task_comments() == [project_task_comment]
    end

    test "get_project_task_comment!/1 returns the project_task_comment with given id" do
      project_task_comment = project_task_comment_fixture()
      assert ProjectTaskComments.get_project_task_comment!(project_task_comment.id) == project_task_comment
    end

    test "create_project_task_comment/1 with valid data creates a project_task_comment" do
      valid_attrs = %{attachment: "some attachment", comment: "some comment"}

      assert {:ok, %ProjectTaskComment{} = project_task_comment} = ProjectTaskComments.create_project_task_comment(valid_attrs)
      assert project_task_comment.attachment == "some attachment"
      assert project_task_comment.comment == "some comment"
    end

    test "create_project_task_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectTaskComments.create_project_task_comment(@invalid_attrs)
    end

    test "update_project_task_comment/2 with valid data updates the project_task_comment" do
      project_task_comment = project_task_comment_fixture()
      update_attrs = %{attachment: "some updated attachment", comment: "some updated comment"}

      assert {:ok, %ProjectTaskComment{} = project_task_comment} = ProjectTaskComments.update_project_task_comment(project_task_comment, update_attrs)
      assert project_task_comment.attachment == "some updated attachment"
      assert project_task_comment.comment == "some updated comment"
    end

    test "update_project_task_comment/2 with invalid data returns error changeset" do
      project_task_comment = project_task_comment_fixture()
      assert {:error, %Ecto.Changeset{}} = ProjectTaskComments.update_project_task_comment(project_task_comment, @invalid_attrs)
      assert project_task_comment == ProjectTaskComments.get_project_task_comment!(project_task_comment.id)
    end

    test "delete_project_task_comment/1 deletes the project_task_comment" do
      project_task_comment = project_task_comment_fixture()
      assert {:ok, %ProjectTaskComment{}} = ProjectTaskComments.delete_project_task_comment(project_task_comment)
      assert_raise Ecto.NoResultsError, fn -> ProjectTaskComments.get_project_task_comment!(project_task_comment.id) end
    end

    test "change_project_task_comment/1 returns a project_task_comment changeset" do
      project_task_comment = project_task_comment_fixture()
      assert %Ecto.Changeset{} = ProjectTaskComments.change_project_task_comment(project_task_comment)
    end
  end
end
