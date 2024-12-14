defmodule VirgilErpWeb.InvoiceLiveTest do
  use VirgilErpWeb.ConnCase

  import Phoenix.LiveViewTest
  import VirgilErp.InvoicesFixtures

  @create_attrs %{amount: 120.5, client: "some client", invoice_id: "some invoice_id", is_paid: true, pay_by_date: "2024-12-13", terms_and_conditions: "some terms_and_conditions"}
  @update_attrs %{amount: 456.7, client: "some updated client", invoice_id: "some updated invoice_id", is_paid: false, pay_by_date: "2024-12-14", terms_and_conditions: "some updated terms_and_conditions"}
  @invalid_attrs %{amount: nil, client: nil, invoice_id: nil, is_paid: false, pay_by_date: nil, terms_and_conditions: nil}

  defp create_invoice(_) do
    invoice = invoice_fixture()
    %{invoice: invoice}
  end

  describe "Index" do
    setup [:create_invoice]

    test "lists all invoices", %{conn: conn, invoice: invoice} do
      {:ok, _index_live, html} = live(conn, ~p"/invoices")

      assert html =~ "Listing Invoices"
      assert html =~ invoice.client
    end

    test "saves new invoice", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("a", "New Invoice") |> render_click() =~
               "New Invoice"

      assert_patch(index_live, ~p"/invoices/new")

      assert index_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invoice-form", invoice: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invoices")

      html = render(index_live)
      assert html =~ "Invoice created successfully"
      assert html =~ "some client"
    end

    test "updates invoice in listing", %{conn: conn, invoice: invoice} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("#invoices-#{invoice.id} a", "Edit") |> render_click() =~
               "Edit Invoice"

      assert_patch(index_live, ~p"/invoices/#{invoice}/edit")

      assert index_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invoice-form", invoice: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invoices")

      html = render(index_live)
      assert html =~ "Invoice updated successfully"
      assert html =~ "some updated client"
    end

    test "deletes invoice in listing", %{conn: conn, invoice: invoice} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("#invoices-#{invoice.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#invoices-#{invoice.id}")
    end
  end

  describe "Show" do
    setup [:create_invoice]

    test "displays invoice", %{conn: conn, invoice: invoice} do
      {:ok, _show_live, html} = live(conn, ~p"/invoices/#{invoice}")

      assert html =~ "Show Invoice"
      assert html =~ invoice.client
    end

    test "updates invoice within modal", %{conn: conn, invoice: invoice} do
      {:ok, show_live, _html} = live(conn, ~p"/invoices/#{invoice}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Invoice"

      assert_patch(show_live, ~p"/invoices/#{invoice}/show/edit")

      assert show_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#invoice-form", invoice: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/invoices/#{invoice}")

      html = render(show_live)
      assert html =~ "Invoice updated successfully"
      assert html =~ "some updated client"
    end
  end
end
