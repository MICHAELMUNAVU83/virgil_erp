defmodule VirgilErp.AcessEmails.AccessEmail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "access_emails" do
    field :active, :boolean, default: false
    field :owner_id, :id
    field :user_id, :id
    field :project_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(access_email, attrs) do
    access_email
    |> cast(attrs, [:active])
    |> validate_required([:active])
  end
end
