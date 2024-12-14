defmodule VirgilErp.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :amount, :float
    field :attached_recepit, :string
    field :paid_at, :date
    field :reason, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :reason, :paid_at, :attached_recepit])
    |> validate_required([:amount, :reason, :paid_at, :attached_recepit])
  end
end
