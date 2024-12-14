defmodule VirgilErpWeb.ProjectTaskAssigneeLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.ProjectTaskAssignees

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project_task_assignee records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="project_task_assignee-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Project task assignee</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{project_task_assignee: project_task_assignee} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ProjectTaskAssignees.change_project_task_assignee(project_task_assignee))
     end)}
  end

  @impl true
  def handle_event("validate", %{"project_task_assignee" => project_task_assignee_params}, socket) do
    changeset = ProjectTaskAssignees.change_project_task_assignee(socket.assigns.project_task_assignee, project_task_assignee_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"project_task_assignee" => project_task_assignee_params}, socket) do
    save_project_task_assignee(socket, socket.assigns.action, project_task_assignee_params)
  end

  defp save_project_task_assignee(socket, :edit, project_task_assignee_params) do
    case ProjectTaskAssignees.update_project_task_assignee(socket.assigns.project_task_assignee, project_task_assignee_params) do
      {:ok, project_task_assignee} ->
        notify_parent({:saved, project_task_assignee})

        {:noreply,
         socket
         |> put_flash(:info, "Project task assignee updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_project_task_assignee(socket, :new, project_task_assignee_params) do
    case ProjectTaskAssignees.create_project_task_assignee(project_task_assignee_params) do
      {:ok, project_task_assignee} ->
        notify_parent({:saved, project_task_assignee})

        {:noreply,
         socket
         |> put_flash(:info, "Project task assignee created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
