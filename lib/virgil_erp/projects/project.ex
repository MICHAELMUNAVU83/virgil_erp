defmodule VirgilErp.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :design_link, :string
    field :stage, :string
    field :system_link, :string
    field :title, :string
    field :total_payment, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :description, :stage, :system_link, :design_link, :total_payment])
    |> validate_required([:title, :description, :stage, :system_link, :design_link, :total_payment])
  end
end
