defmodule VirgilErp.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :description, :string
    field :due_by, :utc_datetime
    field :is_completed, :boolean, default: false
    field :name, :string
    field :remind_at, :utc_datetime
    field :remind_by, :utc_datetime
    field :assignee_id, :id
    field :assigneer_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:name, :description, :due_by, :remind_at, :remind_by, :is_completed, :assignee_id, :assigneer_id])
    |> validate_required([:name, :description, :is_completed])
  end
end
