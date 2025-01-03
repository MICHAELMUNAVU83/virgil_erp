defmodule VirgilErp.Revenues do
  @moduledoc """
  The Revenues context.
  """

  import Ecto.Query, warn: false
  alias VirgilErp.Repo

  alias VirgilErp.Revenues.Revenue

  @doc """
  Returns the list of revenues.

  ## Examples

      iex> list_revenues()
      [%Revenue{}, ...]

  """
  def list_revenues do
    Repo.all(Revenue)
    |> Repo.preload([:user, :project, :invoice])
  end

  @doc """
  Gets a single revenue.

  Raises `Ecto.NoResultsError` if the Revenue does not exist.

  ## Examples

      iex> get_revenue!(123)
      %Revenue{}

      iex> get_revenue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_revenue!(id), do: Repo.get!(Revenue, id)

  @doc """
  Creates a revenue.

  ## Examples

      iex> create_revenue(%{field: value})
      {:ok, %Revenue{}}

      iex> create_revenue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_revenue(attrs \\ %{}) do
    %Revenue{}
    |> Revenue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a revenue.

  ## Examples

      iex> update_revenue(revenue, %{field: new_value})
      {:ok, %Revenue{}}

      iex> update_revenue(revenue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_revenue(%Revenue{} = revenue, attrs) do
    revenue
    |> Revenue.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a revenue.

  ## Examples

      iex> delete_revenue(revenue)
      {:ok, %Revenue{}}

      iex> delete_revenue(revenue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_revenue(%Revenue{} = revenue) do
    Repo.delete(revenue)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking revenue changes.

  ## Examples

      iex> change_revenue(revenue)
      %Ecto.Changeset{data: %Revenue{}}

  """
  def change_revenue(%Revenue{} = revenue, attrs \\ %{}) do
    Revenue.changeset(revenue, attrs)
  end
end
