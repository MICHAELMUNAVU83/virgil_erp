defmodule VirgilErpWeb.ProjectTaskCommentLiveTest do
  use VirgilErpWeb.ConnCase

  import Phoenix.LiveViewTest
  import VirgilErp.ProjectTaskCommentsFixtures

  @create_attrs %{attachment: "some attachment", comment: "some comment"}
  @update_attrs %{attachment: "some updated attachment", comment: "some updated comment"}
  @invalid_attrs %{attachment: nil, comment: nil}

  defp create_project_task_comment(_) do
    project_task_comment = project_task_comment_fixture()
    %{project_task_comment: project_task_comment}
  end

  describe "Index" do
    setup [:create_project_task_comment]

    test "lists all project_task_comments", %{conn: conn, project_task_comment: project_task_comment} do
      {:ok, _index_live, html} = live(conn, ~p"/project_task_comments")

      assert html =~ "Listing Project task comments"
      assert html =~ project_task_comment.attachment
    end

    test "saves new project_task_comment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/project_task_comments")

      assert index_live |> element("a", "New Project task comment") |> render_click() =~
               "New Project task comment"

      assert_patch(index_live, ~p"/project_task_comments/new")

      assert index_live
             |> form("#project_task_comment-form", project_task_comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_task_comment-form", project_task_comment: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_task_comments")

      html = render(index_live)
      assert html =~ "Project task comment created successfully"
      assert html =~ "some attachment"
    end

    test "updates project_task_comment in listing", %{conn: conn, project_task_comment: project_task_comment} do
      {:ok, index_live, _html} = live(conn, ~p"/project_task_comments")

      assert index_live |> element("#project_task_comments-#{project_task_comment.id} a", "Edit") |> render_click() =~
               "Edit Project task comment"

      assert_patch(index_live, ~p"/project_task_comments/#{project_task_comment}/edit")

      assert index_live
             |> form("#project_task_comment-form", project_task_comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_task_comment-form", project_task_comment: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_task_comments")

      html = render(index_live)
      assert html =~ "Project task comment updated successfully"
      assert html =~ "some updated attachment"
    end

    test "deletes project_task_comment in listing", %{conn: conn, project_task_comment: project_task_comment} do
      {:ok, index_live, _html} = live(conn, ~p"/project_task_comments")

      assert index_live |> element("#project_task_comments-#{project_task_comment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#project_task_comments-#{project_task_comment.id}")
    end
  end

  describe "Show" do
    setup [:create_project_task_comment]

    test "displays project_task_comment", %{conn: conn, project_task_comment: project_task_comment} do
      {:ok, _show_live, html} = live(conn, ~p"/project_task_comments/#{project_task_comment}")

      assert html =~ "Show Project task comment"
      assert html =~ project_task_comment.attachment
    end

    test "updates project_task_comment within modal", %{conn: conn, project_task_comment: project_task_comment} do
      {:ok, show_live, _html} = live(conn, ~p"/project_task_comments/#{project_task_comment}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project task comment"

      assert_patch(show_live, ~p"/project_task_comments/#{project_task_comment}/show/edit")

      assert show_live
             |> form("#project_task_comment-form", project_task_comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#project_task_comment-form", project_task_comment: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/project_task_comments/#{project_task_comment}")

      html = render(show_live)
      assert html =~ "Project task comment updated successfully"
      assert html =~ "some updated attachment"
    end
  end
end
