defmodule VirgilErp.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.Expenses` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        attached_recepit: "some attached_recepit",
        paid_at: ~D[2024-12-13],
        reason: "some reason"
      })
      |> VirgilErp.Expenses.create_expense()

    expense
  end
end
