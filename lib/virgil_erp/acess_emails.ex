defmodule VirgilErp.AcessEmails do
  @moduledoc """
  The AcessEmails context.
  """

  import Ecto.Query, warn: false
  alias VirgilErp.Repo

  alias VirgilErp.AcessEmails.AccessEmail

  @doc """
  Returns the list of access_emails.

  ## Examples

      iex> list_access_emails()
      [%AccessEmail{}, ...]

  """
  def list_access_emails do
    Repo.all(AccessEmail)
  end

  @doc """
  Gets a single access_email.

  Raises `Ecto.NoResultsError` if the Access email does not exist.

  ## Examples

      iex> get_access_email!(123)
      %AccessEmail{}

      iex> get_access_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_access_email!(id), do: Repo.get!(AccessEmail, id)

  @doc """
  Creates a access_email.

  ## Examples

      iex> create_access_email(%{field: value})
      {:ok, %AccessEmail{}}

      iex> create_access_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_access_email(attrs \\ %{}) do
    %AccessEmail{}
    |> AccessEmail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a access_email.

  ## Examples

      iex> update_access_email(access_email, %{field: new_value})
      {:ok, %AccessEmail{}}

      iex> update_access_email(access_email, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_access_email(%AccessEmail{} = access_email, attrs) do
    access_email
    |> AccessEmail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a access_email.

  ## Examples

      iex> delete_access_email(access_email)
      {:ok, %AccessEmail{}}

      iex> delete_access_email(access_email)
      {:error, %Ecto.Changeset{}}

  """
  def delete_access_email(%AccessEmail{} = access_email) do
    Repo.delete(access_email)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking access_email changes.

  ## Examples

      iex> change_access_email(access_email)
      %Ecto.Changeset{data: %AccessEmail{}}

  """
  def change_access_email(%AccessEmail{} = access_email, attrs \\ %{}) do
    AccessEmail.changeset(access_email, attrs)
  end
end
