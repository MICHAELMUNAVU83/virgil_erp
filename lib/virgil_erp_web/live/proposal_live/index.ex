defmodule VirgilErpWeb.ProposalLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.Proposals
  alias VirgilErp.Proposals.Proposal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :proposals, Proposals.list_proposals())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Proposal")
    |> assign(:proposal, Proposals.get_proposal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Proposal")
    |> assign(:proposal, %Proposal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Proposals")
    |> assign(:proposal, nil)
  end

  @impl true
  def handle_info({VirgilErpWeb.ProposalLive.FormComponent, {:saved, proposal}}, socket) do
    {:noreply, stream_insert(socket, :proposals, proposal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    proposal = Proposals.get_proposal!(id)
    {:ok, _} = Proposals.delete_proposal(proposal)

    {:noreply, stream_delete(socket, :proposals, proposal)}
  end
end
