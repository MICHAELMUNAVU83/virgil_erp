defmodule VirgilErp.AcessEmailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.AcessEmails` context.
  """

  @doc """
  Generate a access_email.
  """
  def access_email_fixture(attrs \\ %{}) do
    {:ok, access_email} =
      attrs
      |> Enum.into(%{
        active: true
      })
      |> VirgilErp.AcessEmails.create_access_email()

    access_email
  end
end
