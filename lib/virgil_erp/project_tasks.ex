defmodule VirgilErp.ProjectTasks do
  @moduledoc """
  The ProjectTasks context.
  """

  import Ecto.Query, warn: false
  alias VirgilErp.Repo

  alias VirgilErp.ProjectTasks.ProjectTask

  @doc """
  Returns the list of project_tasks.

  ## Examples

      iex> list_project_tasks()
      [%ProjectTask{}, ...]

  """
  def list_project_tasks do
    Repo.all(ProjectTask)
  end

  @doc """
  Gets a single project_task.

  Raises `Ecto.NoResultsError` if the Project task does not exist.

  ## Examples

      iex> get_project_task!(123)
      %ProjectTask{}

      iex> get_project_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_task!(id), do: Repo.get!(ProjectTask, id)

  @doc """
  Creates a project_task.

  ## Examples

      iex> create_project_task(%{field: value})
      {:ok, %ProjectTask{}}

      iex> create_project_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_task(attrs \\ %{}) do
    %ProjectTask{}
    |> ProjectTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_task.

  ## Examples

      iex> update_project_task(project_task, %{field: new_value})
      {:ok, %ProjectTask{}}

      iex> update_project_task(project_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_task(%ProjectTask{} = project_task, attrs) do
    project_task
    |> ProjectTask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project_task.

  ## Examples

      iex> delete_project_task(project_task)
      {:ok, %ProjectTask{}}

      iex> delete_project_task(project_task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_task(%ProjectTask{} = project_task) do
    Repo.delete(project_task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_task changes.

  ## Examples

      iex> change_project_task(project_task)
      %Ecto.Changeset{data: %ProjectTask{}}

  """
  def change_project_task(%ProjectTask{} = project_task, attrs \\ %{}) do
    ProjectTask.changeset(project_task, attrs)
  end
end
