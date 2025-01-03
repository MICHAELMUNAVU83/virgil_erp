defmodule VirgilErp.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :amount, :float
    field :attached_receipt, :string
    field :paid_at, :date
    field :reason, :string
    belongs_to :user, VirgilErp.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :reason, :paid_at, :attached_receipt, :user_id])
    |> validate_required([:amount, :reason, :user_id])
  end
end
