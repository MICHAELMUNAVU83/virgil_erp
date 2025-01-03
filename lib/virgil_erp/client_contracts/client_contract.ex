defmodule VirgilErp.ClientContracts.ClientContract do
  use Ecto.Schema
  import Ecto.Changeset

  schema "client_contracts" do
    field :client, :string
    field :date, :date
    field :description, :string
    field :signed_contract, :string
    field :template_link, :string
    belongs_to :user, VirgilErp.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(client_contract, attrs) do
    client_contract
    |> cast(attrs, [:signed_contract, :date, :client, :description, :template_link, :user_id])
    |> validate_required([:client, :user_id])
  end
end
