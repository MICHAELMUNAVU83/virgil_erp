defmodule VirgilErpWeb.ProjectTaskCommentLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.ProjectTaskComments
  alias VirgilErp.ProjectTaskComments.ProjectTaskComment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :project_task_comments, ProjectTaskComments.list_project_task_comments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project task comment")
    |> assign(:project_task_comment, ProjectTaskComments.get_project_task_comment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project task comment")
    |> assign(:project_task_comment, %ProjectTaskComment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Project task comments")
    |> assign(:project_task_comment, nil)
  end

  @impl true
  def handle_info({VirgilErpWeb.ProjectTaskCommentLive.FormComponent, {:saved, project_task_comment}}, socket) do
    {:noreply, stream_insert(socket, :project_task_comments, project_task_comment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project_task_comment = ProjectTaskComments.get_project_task_comment!(id)
    {:ok, _} = ProjectTaskComments.delete_project_task_comment(project_task_comment)

    {:noreply, stream_delete(socket, :project_task_comments, project_task_comment)}
  end
end
