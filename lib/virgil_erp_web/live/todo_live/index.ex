defmodule VirgilErpWeb.TodoLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.Todos
  alias VirgilErp.Todos.Todo
  alias VirgilErp.DateFormatter

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
     |> assign(:show_new_todo_form, false)
     |> assign(:selected_priority_color, nil)
     |> assign(:selected_datetime, nil)
     |> assign(:week_offset, 0)
     |> stream(:todos, Todos.list_todos())}
  end

  @impl true
  def handle_params(%{"active_date" => active_date} = params, _url, socket) do
    todos =
      Todos.list_todos_for_a_user_and_date(
        socket.assigns.current_user.id,
        Date.from_iso8601!(active_date)
      )

    {:noreply,
     socket
     |> assign(:active_date, Date.from_iso8601!(active_date))
     |> assign(:show_new_todo_form, false)
     |> assign_new(:form, fn ->
       to_form(Todos.change_todo(%Todo{}))
     end)
     |> assign(
       :dates_for_selection,
       DateFormatter.generate_date_array(Date.utc_today(), socket.assigns.week_offset)
     )
     |> assign(:todos, todos)
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    todos = Todos.list_todos_for_a_user_and_date(socket.assigns.current_user.id, Date.utc_today())

    {:noreply,
     socket
     |> assign(:todos, todos)
     |> assign(:active_date, Date.utc_today())
     |> assign(
       :dates_for_selection,
       DateFormatter.generate_date_array(Date.utc_today())
     )
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true

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

  def handle_event("activate_date", %{"date" => date}, socket) do
    {:noreply,
     socket
     |> push_patch(to: "/todos?active_date=#{date}&week_offset=#{socket.assigns.week_offset}")}
  end

  def handle_event("next_week", _params, socket) do
    active_date =
      DateFormatter.generate_date_array(Date.utc_today(), socket.assigns.week_offset + 1)
      |> Enum.at(0)
      |> Map.get(:date)

    if socket.assigns.week_offset == -1 do
      {:noreply,
       socket
       |> assign(:week_offset, socket.assigns.week_offset + 1)
       |> push_patch(
         to:
           "/todos?active_date=#{Date.utc_today()}&week_offset=#{socket.assigns.week_offset - 1}"
       )}
    else
      {:noreply,
       socket
       |> assign(:week_offset, socket.assigns.week_offset + 1)
       |> push_patch(
         to: "/todos?active_date=#{active_date}&week_offset=#{socket.assigns.week_offset + 1}"
       )}
    end
  end

  def handle_event("previous_week", _params, socket) do
    if socket.assigns.week_offset == 1 do
      {:noreply,
       socket
       |> assign(:week_offset, socket.assigns.week_offset - 1)
       |> push_patch(
         to:
           "/todos?active_date=#{Date.utc_today()}&week_offset=#{socket.assigns.week_offset - 1}"
       )}
    else
      active_date =
        DateFormatter.generate_date_array(Date.utc_today(), socket.assigns.week_offset - 1)
        |> Enum.at(0)
        |> Map.get(:date)

      {:noreply,
       socket
       |> assign(:week_offset, socket.assigns.week_offset - 1)
       |> push_patch(
         to: "/todos?active_date=#{active_date}&week_offset=#{socket.assigns.week_offset - 1}"
       )}
    end
  end

  def handle_event("show_new_todo_form", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_new_todo_form, true)}
  end

  def handle_event("cancel_new_todo_form", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_new_todo_form, false)}
  end

  def handle_event("edit_todo", %{"id" => id}, socket) do
    {:noreply,
     socket
     |> push_navigate(to: "/todos/#{id}/edit")}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end

  def handle_event("complete_todo", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)

    {:ok, _todo} = Todos.update_todo(todo, %{is_completed: true})

    {:noreply,
     socket
     |> assign(
       :todos,
       Todos.list_todos_for_a_user_and_date(
         socket.assigns.current_user.id,
         socket.assigns.active_date
       )
     )}
  end

  def handle_event("save_todo", todo_params, socket) do
    todo_params =
      todo_params
      |> Map.put("due_by", socket.assigns.selected_date || socket.assigns.active_date)
      |> Map.put("remind_at", socket.assigns.selected_datetime)
      |> Map.put("priority", socket.assigns.selected_priority)
      |> Map.put("user_id", socket.assigns.current_user.id)

    case Todos.create_todo(todo_params) do
      {:ok, _todo} ->
        {:noreply,
         socket
         |> assign(
           :todos,
           Todos.list_todos_for_a_user_and_date(
             socket.assigns.current_user.id,
             socket.assigns.active_date
           )
         )
         |> assign_new(:form, fn ->
           to_form(Todos.change_todo(%Todo{}))
         end)
         |> put_flash(:info, "Todo created successfully")
         |> assign(:show_new_todo_form, false)}

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
