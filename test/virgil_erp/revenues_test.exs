defmodule VirgilErp.RevenuesTest do
  use VirgilErp.DataCase

  alias VirgilErp.Revenues

  describe "revenues" do
    alias VirgilErp.Revenues.Revenue

    import VirgilErp.RevenuesFixtures

    @invalid_attrs %{amount: nil, paid_at: nil, paid_through: nil, reason: nil}

    test "list_revenues/0 returns all revenues" do
      revenue = revenue_fixture()
      assert Revenues.list_revenues() == [revenue]
    end

    test "get_revenue!/1 returns the revenue with given id" do
      revenue = revenue_fixture()
      assert Revenues.get_revenue!(revenue.id) == revenue
    end

    test "create_revenue/1 with valid data creates a revenue" do
      valid_attrs = %{amount: 120.5, paid_at: ~D[2024-12-13], paid_through: "some paid_through", reason: "some reason"}

      assert {:ok, %Revenue{} = revenue} = Revenues.create_revenue(valid_attrs)
      assert revenue.amount == 120.5
      assert revenue.paid_at == ~D[2024-12-13]
      assert revenue.paid_through == "some paid_through"
      assert revenue.reason == "some reason"
    end

    test "create_revenue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Revenues.create_revenue(@invalid_attrs)
    end

    test "update_revenue/2 with valid data updates the revenue" do
      revenue = revenue_fixture()
      update_attrs = %{amount: 456.7, paid_at: ~D[2024-12-14], paid_through: "some updated paid_through", reason: "some updated reason"}

      assert {:ok, %Revenue{} = revenue} = Revenues.update_revenue(revenue, update_attrs)
      assert revenue.amount == 456.7
      assert revenue.paid_at == ~D[2024-12-14]
      assert revenue.paid_through == "some updated paid_through"
      assert revenue.reason == "some updated reason"
    end

    test "update_revenue/2 with invalid data returns error changeset" do
      revenue = revenue_fixture()
      assert {:error, %Ecto.Changeset{}} = Revenues.update_revenue(revenue, @invalid_attrs)
      assert revenue == Revenues.get_revenue!(revenue.id)
    end

    test "delete_revenue/1 deletes the revenue" do
      revenue = revenue_fixture()
      assert {:ok, %Revenue{}} = Revenues.delete_revenue(revenue)
      assert_raise Ecto.NoResultsError, fn -> Revenues.get_revenue!(revenue.id) end
    end

    test "change_revenue/1 returns a revenue changeset" do
      revenue = revenue_fixture()
      assert %Ecto.Changeset{} = Revenues.change_revenue(revenue)
    end
  end
end
