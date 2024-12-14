defmodule VirgilErp.Revenues.Revenue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "revenues" do
    field :amount, :float
    field :paid_at, :date
    field :paid_through, :string
    field :reason, :string
    field :project_id, :id
    field :invoice_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(revenue, attrs) do
    revenue
    |> cast(attrs, [:amount, :paid_through, :reason, :paid_at])
    |> validate_required([:amount, :paid_through, :reason, :paid_at])
  end
end
