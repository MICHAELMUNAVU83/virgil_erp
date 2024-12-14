defmodule VirgilErp.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_by: ~U[2024-12-13 09:07:00Z],
        is_completed: true,
        name: "some name",
        remind_at: ~U[2024-12-13 09:07:00Z],
        remind_by: ~U[2024-12-13 09:07:00Z]
      })
      |> VirgilErp.Todos.create_todo()

    todo
  end
end
