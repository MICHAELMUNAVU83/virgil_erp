defmodule VirgilErp.ClientContracts do
  @moduledoc """
  The ClientContracts context.
  """

  import Ecto.Query, warn: false
  alias VirgilErp.Repo

  alias VirgilErp.ClientContracts.ClientContract

  @doc """
  Returns the list of client_contracts.

  ## Examples

      iex> list_client_contracts()
      [%ClientContract{}, ...]

  """
  def list_client_contracts do
    Repo.all(ClientContract)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single client_contract.

  Raises `Ecto.NoResultsError` if the Client contract does not exist.

  ## Examples

      iex> get_client_contract!(123)
      %ClientContract{}

      iex> get_client_contract!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_contract!(id), do: Repo.get!(ClientContract, id)

  @doc """
  Creates a client_contract.

  ## Examples

      iex> create_client_contract(%{field: value})
      {:ok, %ClientContract{}}

      iex> create_client_contract(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_contract(attrs \\ %{}) do
    %ClientContract{}
    |> ClientContract.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_contract.

  ## Examples

      iex> update_client_contract(client_contract, %{field: new_value})
      {:ok, %ClientContract{}}

      iex> update_client_contract(client_contract, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_contract(%ClientContract{} = client_contract, attrs) do
    client_contract
    |> ClientContract.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client_contract.

  ## Examples

      iex> delete_client_contract(client_contract)
      {:ok, %ClientContract{}}

      iex> delete_client_contract(client_contract)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_contract(%ClientContract{} = client_contract) do
    Repo.delete(client_contract)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_contract changes.

  ## Examples

      iex> change_client_contract(client_contract)
      %Ecto.Changeset{data: %ClientContract{}}

  """
  def change_client_contract(%ClientContract{} = client_contract, attrs \\ %{}) do
    ClientContract.changeset(client_contract, attrs)
  end
end
