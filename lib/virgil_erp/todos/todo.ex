defmodule VirgilErp.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :description, :string
    field :due_by, :date
    field :is_completed, :boolean, default: false
    field :name, :string
    field :remind_at, :utc_datetime
    belongs_to :user, VirgilErp.Accounts.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [
      :name,
      :description,
      :due_by,
      :remind_at,
      :is_completed,
      :user_id
    ])
    |> validate_required([:name, :is_completed, :user_id])
  end
end
