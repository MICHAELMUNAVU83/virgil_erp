defmodule VirgilErp.Revenues.Revenue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "revenues" do
    field :amount, :float
    field :paid_at, :date
    field :paid_through, :string
    field :reason, :string
    belongs_to :user, VirgilErp.Accounts.User
    belongs_to :project, VirgilErp.Projects.Project
    belongs_to :invoice, VirgilErp.Invoices.Invoice

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(revenue, attrs) do
    revenue
    |> cast(attrs, [:amount, :paid_through, :reason, :paid_at, :user_id, :project_id, :invoice_id])
    |> validate_required([
      :amount,
      :paid_through,
      :reason,
      :paid_at,
      :user_id
    ])
  end
end
