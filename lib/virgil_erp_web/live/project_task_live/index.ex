defmodule VirgilErpWeb.ProjectTaskLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.ProjectTasks
  alias VirgilErp.ProjectTasks.ProjectTask

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :project_tasks, ProjectTasks.list_project_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project task")
    |> assign(:project_task, ProjectTasks.get_project_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project task")
    |> assign(:project_task, %ProjectTask{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Project tasks")
    |> assign(:project_task, nil)
  end

  @impl true
  def handle_info({VirgilErpWeb.ProjectTaskLive.FormComponent, {:saved, project_task}}, socket) do
    {:noreply, stream_insert(socket, :project_tasks, project_task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project_task = ProjectTasks.get_project_task!(id)
    {:ok, _} = ProjectTasks.delete_project_task(project_task)

    {:noreply, stream_delete(socket, :project_tasks, project_task)}
  end
end
