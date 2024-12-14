defmodule VirgilErp.ProposalsTest do
  use VirgilErp.DataCase

  alias VirgilErp.Proposals

  describe "proposals" do
    alias VirgilErp.Proposals.Proposal

    import VirgilErp.ProposalsFixtures

    @invalid_attrs %{client: nil, client_type: nil, description: nil, link_attachment: nil, pdf_attachment: nil}

    test "list_proposals/0 returns all proposals" do
      proposal = proposal_fixture()
      assert Proposals.list_proposals() == [proposal]
    end

    test "get_proposal!/1 returns the proposal with given id" do
      proposal = proposal_fixture()
      assert Proposals.get_proposal!(proposal.id) == proposal
    end

    test "create_proposal/1 with valid data creates a proposal" do
      valid_attrs = %{client: "some client", client_type: "some client_type", description: "some description", link_attachment: "some link_attachment", pdf_attachment: "some pdf_attachment"}

      assert {:ok, %Proposal{} = proposal} = Proposals.create_proposal(valid_attrs)
      assert proposal.client == "some client"
      assert proposal.client_type == "some client_type"
      assert proposal.description == "some description"
      assert proposal.link_attachment == "some link_attachment"
      assert proposal.pdf_attachment == "some pdf_attachment"
    end

    test "create_proposal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Proposals.create_proposal(@invalid_attrs)
    end

    test "update_proposal/2 with valid data updates the proposal" do
      proposal = proposal_fixture()
      update_attrs = %{client: "some updated client", client_type: "some updated client_type", description: "some updated description", link_attachment: "some updated link_attachment", pdf_attachment: "some updated pdf_attachment"}

      assert {:ok, %Proposal{} = proposal} = Proposals.update_proposal(proposal, update_attrs)
      assert proposal.client == "some updated client"
      assert proposal.client_type == "some updated client_type"
      assert proposal.description == "some updated description"
      assert proposal.link_attachment == "some updated link_attachment"
      assert proposal.pdf_attachment == "some updated pdf_attachment"
    end

    test "update_proposal/2 with invalid data returns error changeset" do
      proposal = proposal_fixture()
      assert {:error, %Ecto.Changeset{}} = Proposals.update_proposal(proposal, @invalid_attrs)
      assert proposal == Proposals.get_proposal!(proposal.id)
    end

    test "delete_proposal/1 deletes the proposal" do
      proposal = proposal_fixture()
      assert {:ok, %Proposal{}} = Proposals.delete_proposal(proposal)
      assert_raise Ecto.NoResultsError, fn -> Proposals.get_proposal!(proposal.id) end
    end

    test "change_proposal/1 returns a proposal changeset" do
      proposal = proposal_fixture()
      assert %Ecto.Changeset{} = Proposals.change_proposal(proposal)
    end
  end
end
