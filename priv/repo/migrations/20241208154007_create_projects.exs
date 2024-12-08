defmodule VirgilErp.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string
      add :description, :text
      add :stage, :string
      add :system_link, :string
      add :design_link, :string
      add :total_payment, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:projects, [:user_id])
  end
end
