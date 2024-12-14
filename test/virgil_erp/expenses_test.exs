defmodule VirgilErp.ExpensesTest do
  use VirgilErp.DataCase

  alias VirgilErp.Expenses

  describe "expenses" do
    alias VirgilErp.Expenses.Expense

    import VirgilErp.ExpensesFixtures

    @invalid_attrs %{amount: nil, attached_recepit: nil, paid_at: nil, reason: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Expenses.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Expenses.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{amount: 120.5, attached_recepit: "some attached_recepit", paid_at: ~D[2024-12-13], reason: "some reason"}

      assert {:ok, %Expense{} = expense} = Expenses.create_expense(valid_attrs)
      assert expense.amount == 120.5
      assert expense.attached_recepit == "some attached_recepit"
      assert expense.paid_at == ~D[2024-12-13]
      assert expense.reason == "some reason"
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Expenses.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{amount: 456.7, attached_recepit: "some updated attached_recepit", paid_at: ~D[2024-12-14], reason: "some updated reason"}

      assert {:ok, %Expense{} = expense} = Expenses.update_expense(expense, update_attrs)
      assert expense.amount == 456.7
      assert expense.attached_recepit == "some updated attached_recepit"
      assert expense.paid_at == ~D[2024-12-14]
      assert expense.reason == "some updated reason"
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Expenses.update_expense(expense, @invalid_attrs)
      assert expense == Expenses.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Expenses.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Expenses.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Expenses.change_expense(expense)
    end
  end
end
