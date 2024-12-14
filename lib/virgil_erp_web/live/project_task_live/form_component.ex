defmodule VirgilErpWeb.ProjectTaskLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.ProjectTasks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project_task records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="project_task-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:type]} type="text" label="Type" />
        <.input field={@form[:priority]} type="text" label="Priority" />
        <.input field={@form[:attachment]} type="text" label="Attachment" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Project task</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{project_task: project_task} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ProjectTasks.change_project_task(project_task))
     end)}
  end

  @impl true
  def handle_event("validate", %{"project_task" => project_task_params}, socket) do
    changeset = ProjectTasks.change_project_task(socket.assigns.project_task, project_task_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"project_task" => project_task_params}, socket) do
    save_project_task(socket, socket.assigns.action, project_task_params)
  end

  defp save_project_task(socket, :edit, project_task_params) do
    case ProjectTasks.update_project_task(socket.assigns.project_task, project_task_params) do
      {:ok, project_task} ->
        notify_parent({:saved, project_task})

        {:noreply,
         socket
         |> put_flash(:info, "Project task updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_project_task(socket, :new, project_task_params) do
    case ProjectTasks.create_project_task(project_task_params) do
      {:ok, project_task} ->
        notify_parent({:saved, project_task})

        {:noreply,
         socket
         |> put_flash(:info, "Project task created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
