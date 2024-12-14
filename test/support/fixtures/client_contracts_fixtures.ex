defmodule VirgilErp.ClientContractsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.ClientContracts` context.
  """

  @doc """
  Generate a client_contract.
  """
  def client_contract_fixture(attrs \\ %{}) do
    {:ok, client_contract} =
      attrs
      |> Enum.into(%{
        client: "some client",
        date: ~D[2024-12-13],
        description: "some description",
        signed_contract: "some signed_contract",
        template_link: "some template_link"
      })
      |> VirgilErp.ClientContracts.create_client_contract()

    client_contract
  end
end
