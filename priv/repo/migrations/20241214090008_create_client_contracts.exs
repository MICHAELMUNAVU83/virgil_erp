defmodule VirgilErp.Repo.Migrations.CreateClientContracts do
  use Ecto.Migration

  def change do
    create table(:client_contracts) do
      add :signed_contract, :string
      add :date, :date
      add :client, :string
      add :description, :text
      add :template_link, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:client_contracts, [:user_id])
  end
end
