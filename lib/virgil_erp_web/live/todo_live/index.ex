defmodule VirgilErpWeb.TodoLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.Todos
  alias VirgilErp.Todos.Todo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_new(:form, fn ->
       to_form(Todos.change_todo(%Todo{}))
     end)
     |> assign(:selected_date, nil)
     |> assign(:show_priority_list, false)
     |> assign(:selected_priority, nil)
     |> assign(:selected_priority_color, nil)
     |> assign(:selected_datetime, nil)
     |> stream(:todos, Todos.list_todos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("datetime_selected", %{"value" => value}, socket) do
    {:noreply,
     socket
     |> assign(:selected_datetime, value)}
  end

  def handle_event("datetime_selected", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("date_selected", %{"value" => value}, socket) do
    {:noreply,
     socket
     |> assign(:selected_date, value)}
  end

  def handle_event("date_selected", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("clear_date", _params, socket) do
    {:noreply,
     socket
     |> assign(:selected_date, nil)}
  end

  def handle_event("clear_datetime", _params, socket) do
    {:noreply,
     socket
     |> assign(:selected_datetime, nil)}
  end

  def handle_event("toggle_priority_list", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_priority_list, !socket.assigns.show_priority_list)}
  end

  def handle_event("clear_priority_list", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_priority_list, false)}
  end

  def handle_event("select_priority", %{"priority-name" => priority_name}, socket) do
    {:noreply,
     socket
     |> assign(:show_priority_list, false)
     |> assign(:selected_priority_color, priority_color(priority_name))
     |> assign(:selected_priority, priority_name)}
  end

  def handle_event("clear_priority", _params, socket) do
    {:noreply,
     socket
     |> assign(:selected_priority, nil)
     |> assign(:selected_priority_color, nil)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end

  def handle_event("save_todo", todo_params, socket) do
    todo_params =
      todo_params
      |> Map.put("due_by", socket.assigns.selected_date)
      |> Map.put("remind_at", socket.assigns.selected_datetime)
      |> Map.put("priority", socket.assigns.selected_priority)
      |> Map.put("assignee_id", socket.assigns.current_user.id)

    case Todos.create_todo(todo_params) do
      {:ok, _todo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Todos.get_todo!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign_new(:form, fn ->
      to_form(Todos.change_todo(%Todo{}))
    end)
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_info({VirgilErpWeb.TodoLive.FormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  defp priority_color(priority) do
    case priority do
      "Priority 1" -> "red-500"
      "Priority 2" -> "yellow-500"
      "Priority 3" -> "green-500"
      _ -> "gray-500"
    end
  end
end
