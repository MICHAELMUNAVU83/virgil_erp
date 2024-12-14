defmodule VirgilErpWeb.ProposalLive.Show do
  use VirgilErpWeb, :live_view

  alias VirgilErp.Proposals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:proposal, Proposals.get_proposal!(id))}
  end

  defp page_title(:show), do: "Show Proposal"
  defp page_title(:edit), do: "Edit Proposal"
end
