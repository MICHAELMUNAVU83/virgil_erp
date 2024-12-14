defmodule VirgilErp.InvoicesTest do
  use VirgilErp.DataCase

  alias VirgilErp.Invoices

  describe "invoices" do
    alias VirgilErp.Invoices.Invoice

    import VirgilErp.InvoicesFixtures

    @invalid_attrs %{amount: nil, client: nil, invoice_id: nil, is_paid: nil, pay_by_date: nil, terms_and_conditions: nil}

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Invoices.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Invoices.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      valid_attrs = %{amount: 120.5, client: "some client", invoice_id: "some invoice_id", is_paid: true, pay_by_date: ~D[2024-12-13], terms_and_conditions: "some terms_and_conditions"}

      assert {:ok, %Invoice{} = invoice} = Invoices.create_invoice(valid_attrs)
      assert invoice.amount == 120.5
      assert invoice.client == "some client"
      assert invoice.invoice_id == "some invoice_id"
      assert invoice.is_paid == true
      assert invoice.pay_by_date == ~D[2024-12-13]
      assert invoice.terms_and_conditions == "some terms_and_conditions"
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoices.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      update_attrs = %{amount: 456.7, client: "some updated client", invoice_id: "some updated invoice_id", is_paid: false, pay_by_date: ~D[2024-12-14], terms_and_conditions: "some updated terms_and_conditions"}

      assert {:ok, %Invoice{} = invoice} = Invoices.update_invoice(invoice, update_attrs)
      assert invoice.amount == 456.7
      assert invoice.client == "some updated client"
      assert invoice.invoice_id == "some updated invoice_id"
      assert invoice.is_paid == false
      assert invoice.pay_by_date == ~D[2024-12-14]
      assert invoice.terms_and_conditions == "some updated terms_and_conditions"
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoices.update_invoice(invoice, @invalid_attrs)
      assert invoice == Invoices.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Invoices.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoices.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Invoices.change_invoice(invoice)
    end
  end
end
