defmodule VirgilErp.ProjectTaskComments do
  @moduledoc """
  The ProjectTaskComments context.
  """

  import Ecto.Query, warn: false
  alias VirgilErp.Repo

  alias VirgilErp.ProjectTaskComments.ProjectTaskComment

  @doc """
  Returns the list of project_task_comments.

  ## Examples

      iex> list_project_task_comments()
      [%ProjectTaskComment{}, ...]

  """
  def list_project_task_comments do
    Repo.all(ProjectTaskComment)
  end

  @doc """
  Gets a single project_task_comment.

  Raises `Ecto.NoResultsError` if the Project task comment does not exist.

  ## Examples

      iex> get_project_task_comment!(123)
      %ProjectTaskComment{}

      iex> get_project_task_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_task_comment!(id), do: Repo.get!(ProjectTaskComment, id)

  @doc """
  Creates a project_task_comment.

  ## Examples

      iex> create_project_task_comment(%{field: value})
      {:ok, %ProjectTaskComment{}}

      iex> create_project_task_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_task_comment(attrs \\ %{}) do
    %ProjectTaskComment{}
    |> ProjectTaskComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_task_comment.

  ## Examples

      iex> update_project_task_comment(project_task_comment, %{field: new_value})
      {:ok, %ProjectTaskComment{}}

      iex> update_project_task_comment(project_task_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_task_comment(%ProjectTaskComment{} = project_task_comment, attrs) do
    project_task_comment
    |> ProjectTaskComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project_task_comment.

  ## Examples

      iex> delete_project_task_comment(project_task_comment)
      {:ok, %ProjectTaskComment{}}

      iex> delete_project_task_comment(project_task_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_task_comment(%ProjectTaskComment{} = project_task_comment) do
    Repo.delete(project_task_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_task_comment changes.

  ## Examples

      iex> change_project_task_comment(project_task_comment)
      %Ecto.Changeset{data: %ProjectTaskComment{}}

  """
  def change_project_task_comment(%ProjectTaskComment{} = project_task_comment, attrs \\ %{}) do
    ProjectTaskComment.changeset(project_task_comment, attrs)
  end
end
