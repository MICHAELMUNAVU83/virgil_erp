defmodule VirgilErp.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :amount, :float
    field :client, :string
    field :invoice_id, :string
    field :is_paid, :boolean, default: false
    field :pay_by_date, :date
    field :terms_and_conditions, :string
    field :user_id, :id
    field :project_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:invoice_id, :amount, :pay_by_date, :terms_and_conditions, :client, :is_paid])
    |> validate_required([:invoice_id, :amount, :pay_by_date, :terms_and_conditions, :client, :is_paid])
  end
end
