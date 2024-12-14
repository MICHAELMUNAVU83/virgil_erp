defmodule VirgilErpWeb.ProjectTaskAssigneeLive.Show do
  use VirgilErpWeb, :live_view

  alias VirgilErp.ProjectTaskAssignees

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project_task_assignee, ProjectTaskAssignees.get_project_task_assignee!(id))}
  end

  defp page_title(:show), do: "Show Project task assignee"
  defp page_title(:edit), do: "Edit Project task assignee"
end
