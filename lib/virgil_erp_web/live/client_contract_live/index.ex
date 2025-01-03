defmodule VirgilErpWeb.ClientContractLive.Index do
  use VirgilErpWeb, :live_view

  alias VirgilErp.ClientContracts
  alias VirgilErp.ClientContracts.ClientContract
  alias VirgilErp.DateFormatter

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:client_contracts, ClientContracts.list_client_contracts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Client contract")
    |> assign(:client_contract, ClientContracts.get_client_contract!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Client contract")
    |> assign(:client_contract, %ClientContract{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Client contracts")
    |> assign(:client_contract, nil)
  end

  @impl true
  def handle_info(
        {VirgilErpWeb.ClientContractLive.FormComponent, {:saved, client_contract}},
        socket
      ) do
    {:noreply, stream_insert(socket, :client_contracts, client_contract)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    client_contract = ClientContracts.get_client_contract!(id)
    {:ok, _} = ClientContracts.delete_client_contract(client_contract)

    {:noreply, stream_delete(socket, :client_contracts, client_contract)}
  end
end
