defmodule VirgilErpWeb.ProjectTaskAssigneeLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.ProjectTaskAssignees
  alias VirgilErp.ProjectTaskAssignees.ProjectTaskAssignee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :project_task_assignees, ProjectTaskAssignees.list_project_task_assignees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project task assignee")
    |> assign(:project_task_assignee, ProjectTaskAssignees.get_project_task_assignee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project task assignee")
    |> assign(:project_task_assignee, %ProjectTaskAssignee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Project task assignees")
    |> assign(:project_task_assignee, nil)
  end

  @impl true
  def handle_info({VirgilErpWeb.ProjectTaskAssigneeLive.FormComponent, {:saved, project_task_assignee}}, socket) do
    {:noreply, stream_insert(socket, :project_task_assignees, project_task_assignee)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project_task_assignee = ProjectTaskAssignees.get_project_task_assignee!(id)
    {:ok, _} = ProjectTaskAssignees.delete_project_task_assignee(project_task_assignee)

    {:noreply, stream_delete(socket, :project_task_assignees, project_task_assignee)}
  end
end
