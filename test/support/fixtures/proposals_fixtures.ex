defmodule VirgilErp.ProposalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VirgilErp.Proposals` context.
  """

  @doc """
  Generate a proposal.
  """
  def proposal_fixture(attrs \\ %{}) do
    {:ok, proposal} =
      attrs
      |> Enum.into(%{
        client: "some client",
        client_type: "some client_type",
        description: "some description",
        link_attachment: "some link_attachment",
        pdf_attachment: "some pdf_attachment"
      })
      |> VirgilErp.Proposals.create_proposal()

    proposal
  end
end
