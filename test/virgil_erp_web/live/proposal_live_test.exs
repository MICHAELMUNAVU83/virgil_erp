defmodule VirgilErpWeb.ProposalLiveTest do
  use VirgilErpWeb.ConnCase

  import Phoenix.LiveViewTest
  import VirgilErp.ProposalsFixtures

  @create_attrs %{client: "some client", client_type: "some client_type", description: "some description", link_attachment: "some link_attachment", pdf_attachment: "some pdf_attachment"}
  @update_attrs %{client: "some updated client", client_type: "some updated client_type", description: "some updated description", link_attachment: "some updated link_attachment", pdf_attachment: "some updated pdf_attachment"}
  @invalid_attrs %{client: nil, client_type: nil, description: nil, link_attachment: nil, pdf_attachment: nil}

  defp create_proposal(_) do
    proposal = proposal_fixture()
    %{proposal: proposal}
  end

  describe "Index" do
    setup [:create_proposal]

    test "lists all proposals", %{conn: conn, proposal: proposal} do
      {:ok, _index_live, html} = live(conn, ~p"/proposals")

      assert html =~ "Listing Proposals"
      assert html =~ proposal.client
    end

    test "saves new proposal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/proposals")

      assert index_live |> element("a", "New Proposal") |> render_click() =~
               "New Proposal"

      assert_patch(index_live, ~p"/proposals/new")

      assert index_live
             |> form("#proposal-form", proposal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#proposal-form", proposal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/proposals")

      html = render(index_live)
      assert html =~ "Proposal created successfully"
      assert html =~ "some client"
    end

    test "updates proposal in listing", %{conn: conn, proposal: proposal} do
      {:ok, index_live, _html} = live(conn, ~p"/proposals")

      assert index_live |> element("#proposals-#{proposal.id} a", "Edit") |> render_click() =~
               "Edit Proposal"

      assert_patch(index_live, ~p"/proposals/#{proposal}/edit")

      assert index_live
             |> form("#proposal-form", proposal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#proposal-form", proposal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/proposals")

      html = render(index_live)
      assert html =~ "Proposal updated successfully"
      assert html =~ "some updated client"
    end

    test "deletes proposal in listing", %{conn: conn, proposal: proposal} do
      {:ok, index_live, _html} = live(conn, ~p"/proposals")

      assert index_live |> element("#proposals-#{proposal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#proposals-#{proposal.id}")
    end
  end

  describe "Show" do
    setup [:create_proposal]

    test "displays proposal", %{conn: conn, proposal: proposal} do
      {:ok, _show_live, html} = live(conn, ~p"/proposals/#{proposal}")

      assert html =~ "Show Proposal"
      assert html =~ proposal.client
    end

    test "updates proposal within modal", %{conn: conn, proposal: proposal} do
      {:ok, show_live, _html} = live(conn, ~p"/proposals/#{proposal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Proposal"

      assert_patch(show_live, ~p"/proposals/#{proposal}/show/edit")

      assert show_live
             |> form("#proposal-form", proposal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#proposal-form", proposal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/proposals/#{proposal}")

      html = render(show_live)
      assert html =~ "Proposal updated successfully"
      assert html =~ "some updated client"
    end
  end
end
