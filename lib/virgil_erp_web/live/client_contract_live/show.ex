defmodule VirgilErpWeb.ClientContractLive.Show do
  use VirgilErpWeb, :live_view

  alias VirgilErp.ClientContracts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:client_contract, ClientContracts.get_client_contract!(id))}
  end

  defp page_title(:show), do: "Show Client contract"
  defp page_title(:edit), do: "Edit Client contract"
end
