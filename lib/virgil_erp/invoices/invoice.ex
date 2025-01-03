defmodule VirgilErp.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :amount, :float
    field :client, :string
    field :pdf_attachment, :string
    field :invoice_id, :string
    field :is_paid, :boolean, default: false
    belongs_to :user, VirgilErp.Accounts.User
    belongs_to :project, VirgilErp.Projects.Project
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :amount,
      :client,
      :pdf_attachment,
      :is_paid,
      :user_id,
      :project_id,
      :invoice_id
    ])
    |> validate_required([
      :amount,
      :user_id
    ])
  end
end
