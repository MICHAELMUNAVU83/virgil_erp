defmodule VirgilErp.InvoicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.Invoices` context.
  """

  @doc """
  Generate a invoice.
  """
  def invoice_fixture(attrs \\ %{}) do
    {:ok, invoice} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        client: "some client",
        invoice_id: "some invoice_id",
        is_paid: true,
        pay_by_date: ~D[2024-12-13],
        terms_and_conditions: "some terms_and_conditions"
      })
      |> VirgilErp.Invoices.create_invoice()

    invoice
  end
end
