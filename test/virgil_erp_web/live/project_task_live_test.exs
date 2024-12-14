defmodule VirgilErpWeb.ProjectTaskLiveTest do
  use VirgilErpWeb.ConnCase

  import Phoenix.LiveViewTest
  import VirgilErp.ProjectTasksFixtures

  @create_attrs %{attachment: "some attachment", description: "some description", priority: "some priority", title: "some title", type: "some type"}
  @update_attrs %{attachment: "some updated attachment", description: "some updated description", priority: "some updated priority", title: "some updated title", type: "some updated type"}
  @invalid_attrs %{attachment: nil, description: nil, priority: nil, title: nil, type: nil}

  defp create_project_task(_) do
    project_task = project_task_fixture()
    %{project_task: project_task}
  end

  describe "Index" do
    setup [:create_project_task]

    test "lists all project_tasks", %{conn: conn, project_task: project_task} do
      {:ok, _index_live, html} = live(conn, ~p"/project_tasks")

      assert html =~ "Listing Project tasks"
      assert html =~ project_task.attachment
    end

    test "saves new project_task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/project_tasks")

      assert index_live |> element("a", "New Project task") |> render_click() =~
               "New Project task"

      assert_patch(index_live, ~p"/project_tasks/new")

      assert index_live
             |> form("#project_task-form", project_task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_task-form", project_task: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_tasks")

      html = render(index_live)
      assert html =~ "Project task created successfully"
      assert html =~ "some attachment"
    end

    test "updates project_task in listing", %{conn: conn, project_task: project_task} do
      {:ok, index_live, _html} = live(conn, ~p"/project_tasks")

      assert index_live |> element("#project_tasks-#{project_task.id} a", "Edit") |> render_click() =~
               "Edit Project task"

      assert_patch(index_live, ~p"/project_tasks/#{project_task}/edit")

      assert index_live
             |> form("#project_task-form", project_task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_task-form", project_task: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_tasks")

      html = render(index_live)
      assert html =~ "Project task updated successfully"
      assert html =~ "some updated attachment"
    end

    test "deletes project_task in listing", %{conn: conn, project_task: project_task} do
      {:ok, index_live, _html} = live(conn, ~p"/project_tasks")

      assert index_live |> element("#project_tasks-#{project_task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#project_tasks-#{project_task.id}")
    end
  end

  describe "Show" do
    setup [:create_project_task]

    test "displays project_task", %{conn: conn, project_task: project_task} do
      {:ok, _show_live, html} = live(conn, ~p"/project_tasks/#{project_task}")

      assert html =~ "Show Project task"
      assert html =~ project_task.attachment
    end

    test "updates project_task within modal", %{conn: conn, project_task: project_task} do
      {:ok, show_live, _html} = live(conn, ~p"/project_tasks/#{project_task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project task"

      assert_patch(show_live, ~p"/project_tasks/#{project_task}/show/edit")

      assert show_live
             |> form("#project_task-form", project_task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#project_task-form", project_task: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/project_tasks/#{project_task}")

      html = render(show_live)
      assert html =~ "Project task updated successfully"
      assert html =~ "some updated attachment"
    end
  end
end
