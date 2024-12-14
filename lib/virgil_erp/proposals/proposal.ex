defmodule VirgilErp.Proposals.Proposal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "proposals" do
    field :client, :string
    field :client_type, :string
    field :description, :string
    field :link_attachment, :string
    field :pdf_attachment, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(proposal, attrs) do
    proposal
    |> cast(attrs, [:client, :pdf_attachment, :link_attachment, :client_type, :description])
    |> validate_required([:client, :pdf_attachment, :link_attachment, :client_type, :description])
  end
end
