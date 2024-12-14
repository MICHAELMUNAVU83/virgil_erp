defmodule VirgilErp.TodosTest do
  use VirgilErp.DataCase

  alias VirgilErp.Todos

  describe "todos" do
    alias VirgilErp.Todos.Todo

    import VirgilErp.TodosFixtures

    @invalid_attrs %{description: nil, due_by: nil, is_completed: nil, name: nil, remind_at: nil, remind_by: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{description: "some description", due_by: ~U[2024-12-13 09:07:00Z], is_completed: true, name: "some name", remind_at: ~U[2024-12-13 09:07:00Z], remind_by: ~U[2024-12-13 09:07:00Z]}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.description == "some description"
      assert todo.due_by == ~U[2024-12-13 09:07:00Z]
      assert todo.is_completed == true
      assert todo.name == "some name"
      assert todo.remind_at == ~U[2024-12-13 09:07:00Z]
      assert todo.remind_by == ~U[2024-12-13 09:07:00Z]
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{description: "some updated description", due_by: ~U[2024-12-14 09:07:00Z], is_completed: false, name: "some updated name", remind_at: ~U[2024-12-14 09:07:00Z], remind_by: ~U[2024-12-14 09:07:00Z]}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.description == "some updated description"
      assert todo.due_by == ~U[2024-12-14 09:07:00Z]
      assert todo.is_completed == false
      assert todo.name == "some updated name"
      assert todo.remind_at == ~U[2024-12-14 09:07:00Z]
      assert todo.remind_by == ~U[2024-12-14 09:07:00Z]
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
