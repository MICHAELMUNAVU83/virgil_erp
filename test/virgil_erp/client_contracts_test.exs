defmodule VirgilErp.ClientContractsTest do
  use VirgilErp.DataCase

  alias VirgilErp.ClientContracts

  describe "client_contracts" do
    alias VirgilErp.ClientContracts.ClientContract

    import VirgilErp.ClientContractsFixtures

    @invalid_attrs %{client: nil, date: nil, description: nil, signed_contract: nil, template_link: nil}

    test "list_client_contracts/0 returns all client_contracts" do
      client_contract = client_contract_fixture()
      assert ClientContracts.list_client_contracts() == [client_contract]
    end

    test "get_client_contract!/1 returns the client_contract with given id" do
      client_contract = client_contract_fixture()
      assert ClientContracts.get_client_contract!(client_contract.id) == client_contract
    end

    test "create_client_contract/1 with valid data creates a client_contract" do
      valid_attrs = %{client: "some client", date: ~D[2024-12-13], description: "some description", signed_contract: "some signed_contract", template_link: "some template_link"}

      assert {:ok, %ClientContract{} = client_contract} = ClientContracts.create_client_contract(valid_attrs)
      assert client_contract.client == "some client"
      assert client_contract.date == ~D[2024-12-13]
      assert client_contract.description == "some description"
      assert client_contract.signed_contract == "some signed_contract"
      assert client_contract.template_link == "some template_link"
    end

    test "create_client_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClientContracts.create_client_contract(@invalid_attrs)
    end

    test "update_client_contract/2 with valid data updates the client_contract" do
      client_contract = client_contract_fixture()
      update_attrs = %{client: "some updated client", date: ~D[2024-12-14], description: "some updated description", signed_contract: "some updated signed_contract", template_link: "some updated template_link"}

      assert {:ok, %ClientContract{} = client_contract} = ClientContracts.update_client_contract(client_contract, update_attrs)
      assert client_contract.client == "some updated client"
      assert client_contract.date == ~D[2024-12-14]
      assert client_contract.description == "some updated description"
      assert client_contract.signed_contract == "some updated signed_contract"
      assert client_contract.template_link == "some updated template_link"
    end

    test "update_client_contract/2 with invalid data returns error changeset" do
      client_contract = client_contract_fixture()
      assert {:error, %Ecto.Changeset{}} = ClientContracts.update_client_contract(client_contract, @invalid_attrs)
      assert client_contract == ClientContracts.get_client_contract!(client_contract.id)
    end

    test "delete_client_contract/1 deletes the client_contract" do
      client_contract = client_contract_fixture()
      assert {:ok, %ClientContract{}} = ClientContracts.delete_client_contract(client_contract)
      assert_raise Ecto.NoResultsError, fn -> ClientContracts.get_client_contract!(client_contract.id) end
    end

    test "change_client_contract/1 returns a client_contract changeset" do
      client_contract = client_contract_fixture()
      assert %Ecto.Changeset{} = ClientContracts.change_client_contract(client_contract)
    end
  end
end
