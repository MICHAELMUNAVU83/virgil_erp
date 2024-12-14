defmodule VirgilErp.ProjectTaskAssignees do
  @moduledoc """
  The ProjectTaskAssignees context.
  """

  import Ecto.Query, warn: false
  alias VirgilErp.Repo

  alias VirgilErp.ProjectTaskAssignees.ProjectTaskAssignee

  @doc """
  Returns the list of project_task_assignees.

  ## Examples

      iex> list_project_task_assignees()
      [%ProjectTaskAssignee{}, ...]

  """
  def list_project_task_assignees do
    Repo.all(ProjectTaskAssignee)
  end

  @doc """
  Gets a single project_task_assignee.

  Raises `Ecto.NoResultsError` if the Project task assignee does not exist.

  ## Examples

      iex> get_project_task_assignee!(123)
      %ProjectTaskAssignee{}

      iex> get_project_task_assignee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_task_assignee!(id), do: Repo.get!(ProjectTaskAssignee, id)

  @doc """
  Creates a project_task_assignee.

  ## Examples

      iex> create_project_task_assignee(%{field: value})
      {:ok, %ProjectTaskAssignee{}}

      iex> create_project_task_assignee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_task_assignee(attrs \\ %{}) do
    %ProjectTaskAssignee{}
    |> ProjectTaskAssignee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_task_assignee.

  ## Examples

      iex> update_project_task_assignee(project_task_assignee, %{field: new_value})
      {:ok, %ProjectTaskAssignee{}}

      iex> update_project_task_assignee(project_task_assignee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_task_assignee(%ProjectTaskAssignee{} = project_task_assignee, attrs) do
    project_task_assignee
    |> ProjectTaskAssignee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project_task_assignee.

  ## Examples

      iex> delete_project_task_assignee(project_task_assignee)
      {:ok, %ProjectTaskAssignee{}}

      iex> delete_project_task_assignee(project_task_assignee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_task_assignee(%ProjectTaskAssignee{} = project_task_assignee) do
    Repo.delete(project_task_assignee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_task_assignee changes.

  ## Examples

      iex> change_project_task_assignee(project_task_assignee)
      %Ecto.Changeset{data: %ProjectTaskAssignee{}}

  """
  def change_project_task_assignee(%ProjectTaskAssignee{} = project_task_assignee, attrs \\ %{}) do
    ProjectTaskAssignee.changeset(project_task_assignee, attrs)
  end
end
