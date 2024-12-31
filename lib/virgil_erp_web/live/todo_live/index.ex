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
     |> stream(:todos, Todos.list_todos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end
end
