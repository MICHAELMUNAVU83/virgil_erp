defmodule VirgilErpWeb.ProjectTaskAssigneeLiveTest do
  use VirgilErpWeb.ConnCase

  import Phoenix.LiveViewTest
  import VirgilErp.ProjectTaskAssigneesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_project_task_assignee(_) do
    project_task_assignee = project_task_assignee_fixture()
    %{project_task_assignee: project_task_assignee}
  end

  describe "Index" do
    setup [:create_project_task_assignee]

    test "lists all project_task_assignees", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/project_task_assignees")

      assert html =~ "Listing Project task assignees"
    end

    test "saves new project_task_assignee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/project_task_assignees")

      assert index_live |> element("a", "New Project task assignee") |> render_click() =~
               "New Project task assignee"

      assert_patch(index_live, ~p"/project_task_assignees/new")

      assert index_live
             |> form("#project_task_assignee-form", project_task_assignee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_task_assignee-form", project_task_assignee: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_task_assignees")

      html = render(index_live)
      assert html =~ "Project task assignee created successfully"
    end

    test "updates project_task_assignee in listing", %{conn: conn, project_task_assignee: project_task_assignee} do
      {:ok, index_live, _html} = live(conn, ~p"/project_task_assignees")

      assert index_live |> element("#project_task_assignees-#{project_task_assignee.id} a", "Edit") |> render_click() =~
               "Edit Project task assignee"

      assert_patch(index_live, ~p"/project_task_assignees/#{project_task_assignee}/edit")

      assert index_live
             |> form("#project_task_assignee-form", project_task_assignee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_task_assignee-form", project_task_assignee: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_task_assignees")

      html = render(index_live)
      assert html =~ "Project task assignee updated successfully"
    end

    test "deletes project_task_assignee in listing", %{conn: conn, project_task_assignee: project_task_assignee} do
      {:ok, index_live, _html} = live(conn, ~p"/project_task_assignees")

      assert index_live |> element("#project_task_assignees-#{project_task_assignee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#project_task_assignees-#{project_task_assignee.id}")
    end
  end

  describe "Show" do
    setup [:create_project_task_assignee]

    test "displays project_task_assignee", %{conn: conn, project_task_assignee: project_task_assignee} do
      {:ok, _show_live, html} = live(conn, ~p"/project_task_assignees/#{project_task_assignee}")

      assert html =~ "Show Project task assignee"
    end

    test "updates project_task_assignee within modal", %{conn: conn, project_task_assignee: project_task_assignee} do
      {:ok, show_live, _html} = live(conn, ~p"/project_task_assignees/#{project_task_assignee}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project task assignee"

      assert_patch(show_live, ~p"/project_task_assignees/#{project_task_assignee}/show/edit")

      assert show_live
             |> form("#project_task_assignee-form", project_task_assignee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#project_task_assignee-form", project_task_assignee: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/project_task_assignees/#{project_task_assignee}")

      html = render(show_live)
      assert html =~ "Project task assignee updated successfully"
    end
  end
end
