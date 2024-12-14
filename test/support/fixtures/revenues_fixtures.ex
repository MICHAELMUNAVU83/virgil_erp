defmodule VirgilErp.RevenuesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.Revenues` context.
  """

  @doc """
  Generate a revenue.
  """
  def revenue_fixture(attrs \\ %{}) do
    {:ok, revenue} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        paid_at: ~D[2024-12-13],
        paid_through: "some paid_through",
        reason: "some reason"
      })
      |> VirgilErp.Revenues.create_revenue()

    revenue
  end
end
