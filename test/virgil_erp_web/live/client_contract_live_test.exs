defmodule VirgilErpWeb.ClientContractLiveTest do
  use VirgilErpWeb.ConnCase

  import Phoenix.LiveViewTest
  import VirgilErp.ClientContractsFixtures

  @create_attrs %{client: "some client", date: "2024-12-13", description: "some description", signed_contract: "some signed_contract", template_link: "some template_link"}
  @update_attrs %{client: "some updated client", date: "2024-12-14", description: "some updated description", signed_contract: "some updated signed_contract", template_link: "some updated template_link"}
  @invalid_attrs %{client: nil, date: nil, description: nil, signed_contract: nil, template_link: nil}

  defp create_client_contract(_) do
    client_contract = client_contract_fixture()
    %{client_contract: client_contract}
  end

  describe "Index" do
    setup [:create_client_contract]

    test "lists all client_contracts", %{conn: conn, client_contract: client_contract} do
      {:ok, _index_live, html} = live(conn, ~p"/client_contracts")

      assert html =~ "Listing Client contracts"
      assert html =~ client_contract.client
    end

    test "saves new client_contract", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/client_contracts")

      assert index_live |> element("a", "New Client contract") |> render_click() =~
               "New Client contract"

      assert_patch(index_live, ~p"/client_contracts/new")

      assert index_live
             |> form("#client_contract-form", client_contract: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#client_contract-form", client_contract: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/client_contracts")

      html = render(index_live)
      assert html =~ "Client contract created successfully"
      assert html =~ "some client"
    end

    test "updates client_contract in listing", %{conn: conn, client_contract: client_contract} do
      {:ok, index_live, _html} = live(conn, ~p"/client_contracts")

      assert index_live |> element("#client_contracts-#{client_contract.id} a", "Edit") |> render_click() =~
               "Edit Client contract"

      assert_patch(index_live, ~p"/client_contracts/#{client_contract}/edit")

      assert index_live
             |> form("#client_contract-form", client_contract: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#client_contract-form", client_contract: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/client_contracts")

      html = render(index_live)
      assert html =~ "Client contract updated successfully"
      assert html =~ "some updated client"
    end

    test "deletes client_contract in listing", %{conn: conn, client_contract: client_contract} do
      {:ok, index_live, _html} = live(conn, ~p"/client_contracts")

      assert index_live |> element("#client_contracts-#{client_contract.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#client_contracts-#{client_contract.id}")
    end
  end

  describe "Show" do
    setup [:create_client_contract]

    test "displays client_contract", %{conn: conn, client_contract: client_contract} do
      {:ok, _show_live, html} = live(conn, ~p"/client_contracts/#{client_contract}")

      assert html =~ "Show Client contract"
      assert html =~ client_contract.client
    end

    test "updates client_contract within modal", %{conn: conn, client_contract: client_contract} do
      {:ok, show_live, _html} = live(conn, ~p"/client_contracts/#{client_contract}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Client contract"

      assert_patch(show_live, ~p"/client_contracts/#{client_contract}/show/edit")

      assert show_live
             |> form("#client_contract-form", client_contract: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#client_contract-form", client_contract: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/client_contracts/#{client_contract}")

      html = render(show_live)
      assert html =~ "Client contract updated successfully"
      assert html =~ "some updated client"
    end
  end
end
