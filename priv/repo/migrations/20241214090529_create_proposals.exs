defmodule VirgilErp.Repo.Migrations.CreateProposals do
  use Ecto.Migration

  def change do
    create table(:proposals) do
      add :client, :string
      add :pdf_attachment, :string
      add :link_attachment, :string
      add :client_type, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:proposals, [:user_id])
  end
end
