defmodule VirgilErpWeb.ProjectTaskCommentLive.FormComponent do
  use VirgilErpWeb, :live_component

  alias VirgilErp.ProjectTaskComments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project_task_comment records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="project_task_comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:comment]} type="text" label="Comment" />
        <.input field={@form[:attachment]} type="text" label="Attachment" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Project task comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{project_task_comment: project_task_comment} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ProjectTaskComments.change_project_task_comment(project_task_comment))
     end)}
  end

  @impl true
  def handle_event("validate", %{"project_task_comment" => project_task_comment_params}, socket) do
    changeset = ProjectTaskComments.change_project_task_comment(socket.assigns.project_task_comment, project_task_comment_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"project_task_comment" => project_task_comment_params}, socket) do
    save_project_task_comment(socket, socket.assigns.action, project_task_comment_params)
  end

  defp save_project_task_comment(socket, :edit, project_task_comment_params) do
    case ProjectTaskComments.update_project_task_comment(socket.assigns.project_task_comment, project_task_comment_params) do
      {:ok, project_task_comment} ->
        notify_parent({:saved, project_task_comment})

        {:noreply,
         socket
         |> put_flash(:info, "Project task comment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_project_task_comment(socket, :new, project_task_comment_params) do
    case ProjectTaskComments.create_project_task_comment(project_task_comment_params) do
      {:ok, project_task_comment} ->
        notify_parent({:saved, project_task_comment})

        {:noreply,
         socket
         |> put_flash(:info, "Project task comment created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
